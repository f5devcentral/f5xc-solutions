variable "project_prefix" {
  type        = string
  description = "prefix string put in front of string"
  default     = "f5xc"
}

variable "project_suffix" {
  type        = string
  description = "prefix string put at the end of string"
  default     = "02"
}

variable "project_name" {
  type    = string
  default = "gcp-ce"
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_namespace" {
  type    = string
  default = "system"
}

variable "f5xc_api_token" {
  type = string
}

variable "f5xc_api_p12_file" {
  type = string
}

variable "f5xc_api_url" {
  type = string
}

variable "ssh_public_key_file" {
  type = string
}

variable "gcp_region" {
  type    = string
  default = "us-east1"
  # default = "us-east4"
}

variable "gcp_zone" {
  type    = string
  default = "us-east1-b"
  # default = "us-east4-b
}

variable "gcp_project_id" {
  type = string
}

variable "gcp_application_credentials" {
  type = string
}

variable "cluster_latitude" {
  type    = string
  default = "39.8282"
}

variable "cluster_longitude" {
  type    = string
  default = "-98.5795"
}

variable "fabric_subnet_outside" {
  type    = string
  default = "192.168.0.0/25"
}

variable "fabric_subnet_inside" {
  type    = string
  default = "192.168.0.128/25"
}

variable "machine_image_name" {
  type    = string
  default = "centos7-atomic-20220721105-single-voltmesh-custom"
}

variable "machine_image_base" {
  type = object({
    ingress_gateway        = string
    ingress_egress_gateway = string
  })
  default = {
    ingress_gateway        = "centos7-atomic-20220721105-single-voltmesh-us"
    ingress_egress_gateway = "centos7-atomic-20220721105-multi-voltmesh-us"
  }
}

variable "machine_type" {
  type    = string
  default = "n1-standard-4"
}

variable "machine_disk_size" {
  type    = string
  default = "40"
}

variable "machine_image_family" {
  type    = string
  default = "centos7-atomic"
}

variable "f5xc_ce_gateway_type" {
  type    = string
  # default = "ingress_egress_gateway"
  default = "ingress_gateway"
}

variable "f5xc_ce_image_source_url" {
  type    = string
  default = "https://storage.googleapis.com/ves-images"
}

variable "f5xc_ce_image_file_name_suffix" {
  type    = string
  default = ".tar.gz"
}

variable "f5xc_fleet_label" {
  type    = string
  default = "gcp-ce-test"
}

variable "f5xc_ves_images_base_url" {
  type    = string
  default = "https://storage.googleapis.com/ves-images"
}

variable "owner" {
  type = string
}

variable "f5xc_ip_ranges_Americas_TCP" {
  type = list(string)
}

variable "f5xc_ip_ranges_Americas_UDP" {
  type = list(string)
}

variable "f5xc_ip_ranges_Europe_TCP" {
  type = list(string)
}

variable "f5xc_ip_ranges_Europe_UDP" {
  type = list(string)
}

variable "f5xc_ip_ranges_Asia_TCP" {
  type = list(string)
}

variable "f5xc_ip_ranges_Asia_UDP" {
  type = list(string)
}

variable "f5xc_ce_egress_ip_ranges" {
  type = list(string)
}

locals {
  cluster_labels  = var.f5xc_fleet_label != "" ? { "ves.io/fleet" = var.f5xc_fleet_label } : {}
  f5xc_image_name = format("%s-%s", var.machine_image_name, var.project_suffix)
}

provider "google" {
  credentials = file(var.gcp_application_credentials)
  project     = var.gcp_project_id
  region      = var.gcp_region
  zone        = var.gcp_zone
  alias       = "default"
}

provider "volterra" {
  api_p12_file = var.f5xc_api_p12_file
  url          = var.f5xc_api_url
  alias        = "default"
}

