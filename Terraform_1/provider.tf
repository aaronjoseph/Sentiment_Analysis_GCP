
provider "google" {
  version = "~> 3.31"

  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  version = "~> 3.31"

  project = var.project_id
  region  = var.region
}

/*
provider "google"{
  project = "bt-ai-enablement-ai-dev"
  region = "europe-west2"
  credentials = file("./creds/bt-ai-enablement-ai-dev-a4b40bea56db.json")
}

provider "google-beta"{
  project = "bt-ai-enablement-ai-dev"
  region = "europe-west2"
  credentials = file("./creds/bt-ai-enablement-ai-dev-a4b40bea56db.json")
}
*/
