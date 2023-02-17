# Code versioning
project_id = "<YOUR-PROJECT-ID>" #CHANGEME

#shared virtual private connection

shared_vpc_name    = ""
shared_subnet_name = ""

## Network Related Configuration

vpc_name = "<YOUR-VPC-NAME>" 
subnet_name   = "default"
ip_cidr_range = ""

# notebook vars
service_account_mail = "" #CHANGEME

cloud_function_runtime          = "python37"
cloud_function_available_memory = 256

# Artifact Registry
repo_id     = "docker-repo"
repo_desc   = "repository for Docker images"
repo_format = "DOCKER"