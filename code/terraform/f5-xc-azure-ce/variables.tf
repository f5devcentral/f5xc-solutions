variable "project_prefix" {
  type        = string
  description = "prefix string put in front of string"
  default     = "f5xc"
}

variable "project_suffix" {
  type        = string
  description = "prefix string put at the end of string"
  default     = "10"
}

variable "f5xc_namespace" {
  type    = string
  default = "system"
}

variable "f5xc_azure_region" {
  type    = string
  default = "eastus"
}

variable "f5xc_api_p12_file" {
  type = string
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_api_token" {
  type = string
}

variable "f5xc_azure_marketplace_agreement_publisher" {
  type    = string
  default = "volterraedgeservices"
}

variable "f5xc_azure_marketplace_agreement_offers" {
  type    = map(string)
  default = {
    ingress_egress_gateway = "entcloud_voltmesh_voltstack_node"
    ingress_gateway        = "volterra-node"
    app_stack              = "entcloud_voltmesh_voltstack_node"
  }
}

variable "f5xc_azure_marketplace_agreement_plans" {
  type    = map(string)
  default = {
    ingress_egress_gateway = "freeplan_entcloud_voltmesh_voltstack_node_multinic"
    ingress_gateway        = "volterra-node"
    app_stack              = "freeplan_entcloud_voltmesh_voltstack_node"
  }
}

variable "f5xc_ce_gateway_type" {
  type = string
  validation {
    condition     = contains(["ingress_egress_gateway", "ingress_gateway"], var.f5xc_ce_gateway_type)
    error_message = format("Valid values for gateway_type: ingress_egress_gateway, ingress_gateway")
  }
  default = "ingress_gateway"
}

variable "azure_client_id" {
  type = string
}

variable "azure_client_secret" {
  type = string
}

variable "azure_tenant_id" {
  type = string
}

variable "azure_subscription_id" {
  type = string
}

variable "ssh_public_key_file" {
  type = string
}