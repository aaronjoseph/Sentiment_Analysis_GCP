import os
import importlib
import logging
import tempfile
import datetime
import json
import re
import traceback
from typing import Optional, Tuple
from google import auth
from google.auth.transport import urllib3
from googleapiclient.http import _retry_request
from flask import escape
from flask import request
from flask import Flask
from google.cloud import storage
from google.cloud import aiplatform
from google.cloud.aiplatform import pipeline_jobs
from kfp.v2.google.client import AIPlatformClient

TEMPLATEPATH = "templatePath"
PROJECT = os.getenv("PROJECT")
LOCATION = os.getenv("LOCATION")
PIPELINE_ROOT = os.getenv("PIPELINE_ROOT")
SERVICE_ACCOUNT = os.getenv("SERVICE_ACCOUNT")
storageClient = storage.Client(project=PROJECT)
app = Flask(__name__)
logger = logging.getLogger("gunicorn.error")
app.logger.handlers = logger.handlers
app.logger.setLevel(logger.level)


@app.route("/deployPOST", methods=["GET", "POST"])
def deployPOST(request):
    # request_json = request.get_json(silent=True)
    # # request_json = request_json.decode('utf-8')
    # logger.info(f"request json: {request_json}")
    # print(f"request json: {request_json}")
    # request_args = request.args
    # logger.info(f"request args: {request_args}")
    time = datetime.datetime.now()

    logging.debug("request.headers=%s", request.headers)
    logging.debug("Original request body: %s", request.data)
    templatePath = _preprocess_request_body(
        request_body=request.data,
        time=time,
    )
    logging.debug("Request body: %s", templatePath)

    # default value as parameters are optional
    # parameters = request_json.get('parameters', {})
    try:
        # aiplatform.init(project=PROJECT, location=LOCATION)

        # # TODO handle pipeline parameters
        # pipeline = pipeline_jobs.PipelineJob(
        #     display_name="My example pipeline",
        #     template_path=templatePath,
        #     parameter_values=parameters,
        # )

        # # Unfortuantly run does not return anything instead it logs in the background
        # # TODO even with sync false is stays in the thread and logs the output
        # # https://github.com/googleapis/python-aiplatform/issues/688
        # pipeline.run(sync=False)
        api_client = AIPlatformClient(project_id=PROJECT, region=LOCATION)

        pipeline = api_client.create_run_from_job_spec(
            job_spec_path=templatePath,
            pipeline_root=PIPELINE_ROOT,
            service_account=SERVICE_ACCOUNT,
            enable_caching=True,
        )

        # Return true for now until the SDK returns a proper value for the run
        return {"result": f"{pipeline}"}
    except Exception as e:
        logger.exception(f"error : {str(e)}")
        return {"failure": f"{e}"}, 500


def _preprocess_request_body(
    request_body: bytes,
    time: datetime.datetime,
) -> Tuple[str, str, Optional[bytes]]:
    """Augments the request body before sending it to CAIP Pipelines API.
    Replaces placeholders, generates unique name, removes `_discovery_url`.
    Args:
      request_body: Request body
      time: The scheduled invocation time.
    Returns:
      Tuple of (url, method, resolved_request_body).
    """
    request_str = request_body.decode("utf-8")

    # Replacing placeholders like: {{$.scheduledTime.strftime('%Y-%m-%d')}}
    request_str = re.sub(
        r"{{\$.scheduledTime.strftime\('([^']*)'\)}}",
        lambda m: time.strftime(m.group(1)),
        request_str,
    )

    request_json = json.loads(request_str)

    # validation is manged via PipelineJob
    if request_json:
        templatePath = str(request_json[TEMPLATEPATH])
    else:
        return "bad request! no templatePath found", 400

    return templatePath
