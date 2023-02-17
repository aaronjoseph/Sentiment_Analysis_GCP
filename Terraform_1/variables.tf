#environment variable
variable "require_thea_id" {
  type        = string
  description = "enablement variable"
}

variable "monitoring_config" {
  type        = any
  description = "Monitoring Config for the Dashboard"
  default = {}
}

variable "notebook_name" {
  type        = string
  description = "(Optional) The name of the notebook"
}

variable "notebook_config" {
  type = map(object({
    machine_type           = string
    instance_owner         = string
    vm_project             = string
    image_repository       = string
    image_family           = string
    image_tag              = string
    metadata               = map(string)
    accelerator_type       = string
    accelerator_core_count = number
  }))
  default     = {}
  description = "(Optional) The fields to define our notebook config, either vm_project and image_family are null (when using user's image) or image_repository and image_tag are null (when using Google's image)"
}


/* variable "require_pubsub_trigger_function" {
  type        = string
  description = "enablement variable"
} */

# Cloud Function Variables
variable "http_cloud_function_config" {
  type = map(object({
    runtime               = string
    memory_requirements   = number
    entry_point           = string
    environment_variables = map(string)
  }))
  default     = {}
  description = "(Optional) The fields to define our pubsub function config"
}

variable "scheduler_job_config" {
  type = map(object({
    scheduler_cron   = string
    description      = string
    time_zone        = string
    attempt_deadline = string
  }))
  default     = {}
  description = "(Optional) The fields to define our scheduler job config"
}


variable "cloud_run_config" {
  type = map(object({
    cloud_run_docker_image         = string
    pipeline_root                  = string
    environment_service_account    = string
    cloud_run_service_account_name = string
  }))
  default     = {}
  description = "(Optional) The fields to define cloud run config"
}


variable "cloud_run_scheduler_job" {
  type = map(object({
    scheduler_cron   = string
    description      = string
    time_zone        = string
    attempt_deadline = string
  }))
  default     = {}
  description = "(Optional) The fields to define our cloud run scheduler job config"
}

variable "scheduler_cloud_function_map" {
}

variable "gcs_cloud_function_config" {
  type = map(object({
    runtime               = string
    memory_requirements   = number
    entry_point           = string
    trigger_bucket        = string
    environment_variables = map(string)
  }))
  description = "(Required) The fields to define our gcs function config"
}

variable "pubsub_cloud_function_config" {
  type = map(object({
    runtime               = string
    memory_requirements   = number
    entry_point           = string
    topic_name            = string
    retry_bool            = bool
    environment_variables = map(string)
  }))
  description = "(Required) The fields to define our pubsub function config"
}

variable "pubsub_topic_config" {
  type = map(object({
    publishers_email_list = list(string)
  }))
  description = "Fields with topic configuration"
}



// variable cloud_function_name_gcs_trigger{
//   type        = string
//   default     = "gcs_trigger_pipeline"
//   description = "(Required) The name to be provided for the cloud function - gcs"
// }

// variable trigger_bucket{
//   type        = string
//   default     = "prep_ _pipelines"
//   description = "(Required) Bucket triggering the cloud function"
// }

variable "cloud_function_runtime" {
  type        = string
  default     = "python37"
  description = "(Required) The python version for cloud function"
}

// variable gcs_cloud_function_entry_point{
//   type        = string
//   description = "(Required) Entry Point for Cloud Function"
// }

variable "cloud_function_service_account_email" {
  type        = string
  default     = "ml-pipelines-sa@ - -fact-ml-pipe-exp.iam.gserviceaccount.com"
  description = "(Required) Service Account Email - Cloud Function"
}
variable "gcs_cloud_function_service_account" {
  type        = string
  default     = "ml-pipelines-sa@ - -fact-ml-pipe-exp.iam.gserviceaccount.com"
  description = "(Required) Service Account Email - Cloud Function"
}

variable "cloud_function_available_memory" {
  type        = number
  default     = 128
  description = "(Required) Amount of Available Memory - Cloud Function"
}

variable "sa_roles" {
  type        = string
  default     = "roles/storage.objectViewer"
  description = "(Optional) The roles to apply to the cloud function Service account in the data project"
}

# General Variables

variable "project_id" {
  type        = string
  description = "(Required) The project id in which to create the resource under"
}

variable "versioning" {
  type        = bool
  default     = false
  description = "(Optional) Whether you want versioning enabled for your bucket. Set to False by default"
}

variable "region" {
  type        = string
  default     = "europe-west2"
  description = "Region of the project"
}

variable "vpc_name" {
  type        = string
  description = "(Required) The name of the private VPC"
}

variable "shared_vpc_name" {
  type        = string
  description = "(Required) The name of the shared VPC"
}

variable "shared_subnet_name" {
  type        = string
  description = "(Required) The name of the shared subnet VPC"
}

variable "auto_create_subnetworks" {
  type        = bool
  default     = false
  description = "by default we will not be creating subnets automatically"
}

variable "subnet_name" {
  type        = string
  description = "(Required) The name of the subnet within private VPC"
}

variable "ip_cidr_range" {
  type        = string
  description = "(Required) The CIDR range of subnet within private VPC"
}

#connector variables
variable "connector_name" {
  type        = string
  default     = "cloud-function-connector"
  description = "(Optional) The name of the vpc connector"
}

variable "min_throughput" {
  type        = number
  default     = 200
  description = "(Optional) Minimum throughput of the connector in Mbps. Default and min is 200"
}

variable "max_throughput" {
  type        = number
  default     = 300
  description = "(Optional) Maximum throughput of the connector in Mbps, must be greater than min_throughput. Default is 300"
}

variable "routing_mode" {
  type        = string
  default     = "REGIONAL"
  description = "(Optional) The network-wide routing mode to use. REGIONAL = this network's cloud routers will only advertise routes with subnetworks of this network in the same region as the router"
}


variable "private_ip_google_access" {
  type        = bool
  default     = true
  description = "This indicates that subnet is private to "
}

variable "firewall_name1" {
  type        = string
  default     = "allow-internal"
  description = "Default firewall for allowing internal ports enabled"
}

variable "ip_ranges1_firewall" {
  type        = list(string)
  default     = ["10.128.0.0/9"]
  description = "Ip ranges for which the internal firewall needs to be enabled"
}

variable "firewall_name2" {
  type        = string
  default     = "allow-ssh"
  description = "Default firewall for allowing ssh ports enabled"
}

variable "ip_ranges2_firewall" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "Ip ranges for which the ssh firewall needs to be enabled"
}

variable "no_public_ip" {
  type        = bool
  default     = true
  description = "This enables the selection of IP from private subnet"
}

variable "no_proxy_access" {
  type        = bool
  default     = false
  description = "This setting enables the proxy set up to be enabled"
}

variable "service_account_mail" {
  type        = string
  description = "(Required) mail-id of the service account using which the notebooks interacts with other services."
}


// variable "gke_name" {
//   description = "The name of the GKE cluster"
//   type        = string
// }

// variable "description" {
//   description = "The cluster's description"
//   type        = string
// }

// variable "zone" {
//   description = "The location of the GKE cluster"
//   type        = string
//   default     = "europe-west2"
// }

// variable "gke_service_account_mail" {
//   description = "The cluster's service account full ID"
// }

// variable "cluster_node_count" {
//   description = "The cluster's node count"
//   default     = 3
// }

// variable "networking_mode" {
//   description = "This variable indicates whether the cluster should be private or public"
//   type        = string
//   default     = "VPC_NATIVE"
// }

// variable "cluster_ipv4_cidr_block" {
//   type    = string
//   default = "/16"
// }

// variable "services_ipv4_cidr_block" {
//   type    = string
//   default = "/16"
// }

// variable "cluster_node_type" {
//   description = "The cluster's node type"
//   default     = "n1-standard-1"
// }

// variable "disable_legacy_endpoints" {
//   type    = bool
//   default = true
// }

// variable "auth_scopes_list" {
//   type = list(string)
// }

// variable "enable_private_nodes" {
//   type    = bool
//   default = true
// }

// variable "enable_private_endpoint" {
//   type    = bool
//   default = true
// }

// variable "master_ipv4_cidr_block" {
//   type    = string
//   default = "172.16.0.32/28"
// }

// variable "issue_client_certificate" {
//   type    = bool
//   default = true
// }

// variable "shared_machine_type" {
//   type        = list(string)
//   description = "(Required) Machine type of the notebook"
//   default     = null
// }

// variable "shared_image_family" {
//   type        = list(string)
//   description = "(Required) Image family which needs to installed in the notebook"
//   default     = null
// }

// variable "shared_user_instance_names" {
//   type        = list(string)
//   description = "(Required) Name of the notebook which is being created"
//   default     = null
// }

// variable "global_address_name" {
//   type    = string
//   default = "private-ip-address"
// }

// variable "global_address_purpose" {
//   type    = string
//   default = "VPC_PEERING"
// }

// variable "global_address_type" {
//   type    = string
//   default = "INTERNAL"
// }

// variable "global_address_prefix_length" {
//   type    = number
//   default = 16
// }


// variable "network_connection_service_api" {
//   type    = string
//   default = "servicenetworking.googleapis.com"
// }

// variable "mysql_name" {
//   description = "The instance name"
//   type        = string
// }

// variable "mysql_disk_size" {
//   description = "The size of data disk"
//   default     = 100
// }

// variable "mysql_tier" {
//   description = "The machine type to use"
//   default     = "db-n1-standard-8"
// }

// variable "mysql_dbversion" {
//   description = "The DB version to use"
//   default     = "MYSQL_5_7"
// }

// variable "sql_ipv4_enabled" {
//   type    = bool
//   default = false
// }


// variable "password_length" {
//   type    = number
//   default = 10
// }

// variable "include_special" {
//   type    = bool
//   default = true
// }

// variable "override_special" {
//   type    = string
//   default = "_%@?"
// }

// variable "sql_username" {
//   type    = string
//   default = "pipeline_user"
// }

// #gcs bucket name for dataproc
// variable "staging_bucket" {
//   type        = string
//   description = "Bucket created for dataproc"
// }

# Variables for Pub/Sub Cloud Run

// variable "scheduled_cloud_run_config" {
//     description = "Map of configurations for the scheduled Cloud Run workflow"
//     type = object({
//         cloud_run_docker_image = string
//         cloud_run_service_account_name = string
//         pub_sub_scheduler_service_account_name = string
//         schedulers = map(object({
//             name = string
//             description = string
//             schedule = string
//             attributes = map(string)
//             data = string
//         }))
//     })
// }

// # Variables for Vertex endpoints

// variable "cloud_run_online_serving_config" {
//     description = "Map of configurations for the vertex endpoint"
//     type = map(object({
//         cloud_run_name = string
//         cloud_run_service_account_name = string
//         endpoint_name = string
//         container_path = string
//         container_args = list(string)
//         container_memory = string
//         container_cpu = string
//     }))
// }

// Log Based Alerting Block

// variable "log_based_alerting_config" {
//   type = any
//   default     = {}
//   description = "(Optional) Log Based Alerting for triggering based on filtering criteria"
// }



# Variables for artifact registry

variable "repo_id" {
  type        = string
  description = "(Required) The repository_id for an artifact registry"
}

variable "repo_desc" {
  type        = string
  description = "(Required) The description for an artifact registry"
}

variable "repo_format" {
  type        = string
  description = "(Required) The description for an artifact registry"
}
