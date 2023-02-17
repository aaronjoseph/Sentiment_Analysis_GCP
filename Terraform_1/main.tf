/*

Terraform Section

1. Network Related Configuration
2. Artifact and GCS bucket creation
3. Vertex AI IDE Configuration
4. Cloud Function Resource Configuration
  a. Relevant IAM & SA Configuration
  b. HTTP Function
  d. Cloud Function - Bucket Trigger
  e. PubSub Cloud Function
  f. PubSub topic for CFs
5. Cloud Scheduler Resources
6. Cloud Run Service - Vertex Pipeline Trigger
*/

# Section 1 - Network Related Configuration
# to create own project VPC network and subnet please uncomment next blocks of code
# enabled = var.env in ("prod","exp") ? true : false

// module "vpc" {
//   source                  = "git::https://gitlab.agile.nat. / / /core-templates.git//network/vpc?ref=v1.3.2"
//   vpc_name                = var.vpc_name
//   auto_create_subnetworks = var.auto_create_subnetworks
// }

// module "subnet" {
//   source                   = "git::https://gitlab.agile.nat. / / /core-templates.git//network/subnet?ref=v1.3.2"
//   subnet_name              = var.subnet_name
//   ip_cidr_range            = var.ip_cidr_range
//   region                   = var.region
//   network_id               = module.vpc.vpc_network_id
//   private_ip_google_access = var.private_ip_google_access
// }

// module "internal-firewall" {
//   source           = "git::https://gitlab.agile.nat. / / /core-templates.git//network/firewalls/allow_internal?ref=v1.3.2"
//   firewall_name    = var.firewall_name1
//   vpc_network_name = module.vpc.vpc_network
//   ip_ranges        = var.ip_ranges1_firewall
// }

// module "ssh-firewall" {
//   source           = "git::https://gitlab.agile.nat. / / /core-templates.git//network/firewalls/allow_ssh?ref=v1.3.2"
//   firewall_name    = var.firewall_name2
//   vpc_network_name = module.vpc.vpc_network
//   ip_ranges        = var.ip_ranges2_firewall
// }

# Section 2 - Artifact and GCS bucket creation

# To create GCS resources uncomment next block on code

// module "gcs" {
//   source     = "git::https://gitlab.agile.nat. / / /core-templates.git//gcs?ref=v1.3.2"
//   project_id = var.project_id
//   name       = var.project_id
//   # name variable does not exist, could create it and give a tfvars for it
//   region     = var.region
//   versioning = var.versioning
// }

# To create an artifact registry repository, uncomment the below code

// module "artifact" {
//   source            = "git::https://gitlab.agile.nat. / / /core-templates.git//analytics/artifact_registry"
//   project_id        = var.project_id
//   region            = var.region
//   repo_id           = var.repo_id
//   repo_desc         = var.repo_desc
//   repo_format       = var.repo_format
// }

# Section 3 - Vertex AI IDE Configuration

#These notebooks are created using the shared VPC details - this network is managed by the Core team and are necessary for Gitlab connectivity through notebooks
# Creation of shared notebooks is not for CNN/Data product data connectivity, for that single user notebooks are needed

module "notebooks" {
  source               = "git::https://gitlab.agile.nat. / / /core-templates.git//analytics/notebook?ref=v1.3.2"
  project_id           = var.project_id
  for_each             = var.notebook_config
  notebook_name        = each.key
  notebook_config      = each.value
  no_proxy_access      = var.no_proxy_access
  no_public_ip         = var.no_public_ip
  service_account_mail = var.service_account_mail
  #comment/uncomment according to private vpc configuration or shared vpc configuration
  network_id = var.shared_vpc_name
  subnet_id  = var.shared_subnet_name
  #network_id            = module.vpc.vpc_network_id
  #subnet_id             = module.subnet.vpc_subnet_id
}

# Cloud Function - HTTP
// module "http_cloud_function" {
//   source                              = "git::https://gitlab.agile.nat. / / /core-templates.git//http_cloud_function?ref=v1.3.2"
//   for_each                            = var.http_cloud_function_config
//   region                              = var.region
//   project_id                          = var.project_id
//   function_name                       = each.key
//   function_config                     = each.value
//   http_cloud_function_service_account = "cf-http-sa@${var.project_id}.iam.gserviceaccount.com"
//   vpc_connector                       = module.vpc.connector_id
//   vpc_connector_egress_settings       = "ALL_TRAFFIC"
// }

# Cloud Function - Bucket Trigger
// module "gcs_trigger_function" {
//   source                             = "git::https://gitlab.agile.nat. / / /core-templates.git//storage_cloud_function?ref=v1.3.2"
//   project_id                         = var.project_id
//   for_each                           = var.gcs_cloud_function_config
//   function_name                      = each.key
//   function_config                    = each.value
//   region                             = var.region
//   gcs_cloud_function_service_account = "cf-gcs-sa@${var.project_id}.iam.gserviceaccount.com"
//   vpc_connector                      = module.vpc.connector_id
//   vpc_connector_egress_settings      = "ALL_TRAFFIC"
// }

# PubSub Topic
// module "pubsub_topic" {
//   source       = "git::https://gitlab.agile.nat. / / /core-templates.git//pub_sub?ref=v1.3.2"
//   project_id   = var.project_id
//   for_each     = var.pubsub_topic_config
//   topic_name   = each.key
//   topic_config = each.value
// }

# PubSub Cloud Function
// module "pubsub_trigger_function" {
//   source                                = "git::https://gitlab.agile.nat. / / /core-templates.git//pubsub_cloud_function?ref=v1.3.2"
//   project_id                            = var.project_id
//   for_each                              = var.pubsub_cloud_function_config
//   pubsub_cloud_function_name            = each.key
//   function_config                       = each.value
//   pubsub_cloud_function_service_account = "cf-pubsub-sa@${var.project_id}.iam.gserviceaccount.com"
//   vpc_connector                         = module.vpc.connector_id
//   vpc_connector_egress_settings         = "ALL_TRAFFIC"
//   depends_on = [
//     module.pubsub_topic,
//   ]
// }

# Section 5 - Cloud Scheduler Resources
// module "cloud_scheduler" {
//   for_each              = var.scheduler_job_config
//   source                = "git::https://gitlab.agile.nat. / / /core-templates.git//cloud_scheduler?ref=v1.3.2"
//   project_id            = var.project_id
//   region                = var.region
//   description           = each.value.description
//   schedule_name         = each.key
//   schedule_cron         = each.value.scheduler_cron
//   time_zone             = each.value.time_zone
//   attempt_deadline      = each.value.attempt_deadline
//   service_account_email = "scheduler-sa@${var.project_id}.iam.gserviceaccount.com"
//   uri                   = module.http_cloud_function[lookup(var.scheduler_cloud_function_map, each.key)].https_trigger_url
//   audience              = module.http_cloud_function[lookup(var.scheduler_cloud_function_map, each.key)].https_trigger_url
//   depends_on = [
//     module.http_cloud_function,
//   ]
// }

# Section 6 - Cloud Run Service - Vertex Pipeline trigger
// module "cloudRunPipelineTrigger" {
//   for_each                       = var.cloud_run_config
//   source                         = "git::https://gitlab.agile.nat. / / /core-templates.git//cloud_run?ref=v1.3.2"
//   project_id                     = var.project_id
//   cloud_run_service_name         = each.key
//   cloud_run_docker_image         = each.value.cloud_run_docker_image
//   cloud_run_service_account_name = each.value.cloud_run_service_account_name
//   vpc_connector_id               = module.vpc.connector_id
//   pipeline_root                  = each.value.pipeline_root
//   environment_service_account    = each.value.environment_service_account
//   depends_on = [
//     module.vpc,
//   ]
// }

// module "cloud_run_scheduler" {
//   for_each         = var.cloud_run_scheduler_job
//   source           = "git::https://gitlab.agile.nat. / / /core-templates.git//cloud_scheduler?ref=v1.3.2"
//   project_id       = var.project_id
//   region           = var.region
//   description      = each.value.description
//   schedule_name    = each.key
//   schedule_cron    = each.value.scheduler_cron
//   time_zone        = each.value.time_zone
//   attempt_deadline = each.value.attempt_deadline
//   uri              = module.cloudRunPipelineTrigger[lookup(var.scheduler_cloud_function_map, each.key)].url

//   service_account_email = "scheduler-sa@${var.project_id}.iam.gserviceaccount.com"
//   audience              = module.cloudRunPipelineTrigger[lookup(var.scheduler_cloud_function_map, each.key)].url

//   depends_on = [
//     module.cloudRunPipelineTrigger,
//   ]
// }

// module "pub_sub_cloud_run" {
//    source  = "git::https://gitlab.agile.nat. / / /core-templates.git//pubsub_cloud_run?ref=v1.3.4"
//     project_id = var.project_id
//     region = var.region
//     cloud_run_docker_image = var.scheduled_cloud_run_config.cloud_run_docker_image
//     cloud_run_service_account_name = var.scheduled_cloud_run_config.cloud_run_service_account_name
//     pub_sub_scheduler_service_account_name = var.scheduled_cloud_run_config.pub_sub_scheduler_service_account_name
//     schedulers = var.scheduled_cloud_run_config.schedulers
//     vpc_connector = module.vpc.connector_id
// }

// module "cloud_run_online_serving" {
//     source        = "git::https://gitlab.agile.nat. / / /core-templates.git//cloud_run_online_serving?ref=dev_branch"
//     for_each      = var.cloud_run_online_serving_config
//     project_id    = var.project_id
//     region        = var.region
//     cloud_run_name = each.value.cloud_run_name
//     cloud_run_service_account_name = each.value.cloud_run_service_account_name
//     endpoint_name   = each.value.endpoint_name
//     container_path = each.value.container_path
//     container_args = each.value.container_args
//     container_memory = each.value.container_memory
//     container_cpu = each.value.container_cpu
// }


// module "log_based_alerting" {
//   for_each                  = var.log_based_alerting_config
//   source           = "git::https://gitlab.agile.nat. / / / -modules/ -monitoring-module.git"
//   service_alert_name        = each.key
//   notification_type         = each.value.notification_type
//   notification             = each.value.notification
//   filter_condition          = each.value.filter_condition
//   auto_close                = each.value.auto_close
//   period                    = each.value.period

// }

// resource "google_monitoring_dashboard" "dashboard" {
//   for_each = var.monitoring_config
//   dashboard_json = file(each.value)
  
// }

