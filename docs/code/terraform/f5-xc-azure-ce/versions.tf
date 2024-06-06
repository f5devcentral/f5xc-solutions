terraform {
  required_version = ">= 1.3.0"
  cloud {
    organization = "f5xc"
    hostname     = "app.terraform.io"

    workspaces {
      name = "f5-xc-azure-ce-module"
    }
  }
  
  required_providers {
    volterra = {
      source = "volterraedge/volterra"
      version = "= 0.11.20"
    }
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 3.25.0"
    }
    local = ">= 2.2.3"
    null = ">= 3.1.1"
  }
}