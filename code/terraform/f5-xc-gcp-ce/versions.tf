terraform {
  required_version = ">= 1.3.0"
  cloud {
    organization = "f5xc"
    hostname     = "app.terraform.io"

    workspaces {
      name = "f5-xc-gcp-ce-module"
    }
  }
  
  required_providers {
    volterra = {
      source = "volterraedge/volterra"
      version = "= 0.11.21"
    }
    google = {
      source = "hashicorp/google"
      version = ">= 4.48.0"
    }
    local = ">= 2.2.3"
    null = ">= 3.1.1"
  }
}