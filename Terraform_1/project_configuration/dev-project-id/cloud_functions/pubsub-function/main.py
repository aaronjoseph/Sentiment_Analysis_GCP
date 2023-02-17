"""Cloud Function to be triggered by Pub/Sub."""

import os
import json
import logging
from kfp.v2.google.client import AIPlatformClient
from google.cloud import storage
import base64


def trigger_pipeline(event, context):
    project = os.getenv("PROJECT")
    region = os.getenv("LOCATION")
    pipeline_root = os.getenv("PIPELINE_ROOT")
    pipeline_service_account = os.getenv("PIPELINE_SERVICE_ACCOUNT")

    if not project:
        raise ValueError("Environment variable PROJECT is not set.")
    if not region:
        raise ValueError("Environment variable REGION is not set.")

    storage_client = storage.Client()

    gcs_pipeline_file_location = base64.b64decode(event["data"]).decode("utf-8")

    logging.info(f"Pipeline to run: {gcs_pipeline_file_location}")

    path_parts = gcs_pipeline_file_location.replace("gs://", "").split("/")
    bucket_name = path_parts[0]
    blob_name = "/".join(path_parts[1:])

    bucket = storage_client.bucket(bucket_name)
    blob = storage.Blob(bucket=bucket, name=blob_name)

    if not blob.exists(storage_client):
        raise ValueError(f"{gcs_pipeline_file_location} does not exist.")

    api_client = AIPlatformClient(project_id=project, region=region)

    response = api_client.create_run_from_job_spec(
        job_spec_path=gcs_pipeline_file_location,
        service_account=pipeline_service_account,
        pipeline_root=pipeline_root,
    )

    logging.info(response)
