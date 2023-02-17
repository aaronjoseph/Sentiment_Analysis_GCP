from kfp.v2.google.client import AIPlatformClient
import logging
import os


# pick environment varible.
PROJECT = os.getenv("PROJECT")
REGION = os.getenv("REGION")
PIPELINE_ROOT = os.getenv("PIPELINE_ROOT")
SERVICE_ACCOUNT = os.getenv("SERVICE_ACCOUNT")
PIPELINE_SPEC_PATH = os.getenv("PIPELINE_SPEC_PATH")
logger = logging.getLogger("gunicorn.error")


def vertex_ai_pipeline_trigger(event, context):
    try:
        api_client = AIPlatformClient(project_id=PROJECT, region=REGION)
        print("api_client is successfully instantiated")
        response = api_client.create_run_from_job_spec(
            PIPELINE_SPEC_PATH,
            pipeline_root=PIPELINE_ROOT,
            service_account=SERVICE_ACCOUNT,
            parameter_values={"project": PROJECT},
        )
        return {"result": f"{response}"}
    except Exception as e:
        logger.exception(f"error : {str(e)}")
        return {"failure": f"{e}"}, 500
