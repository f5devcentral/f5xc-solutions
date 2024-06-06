# F5XC GCP CLOUD CE

Terraform to create F5XC GCP cloud CE

## Usage

- Clone this repo with: `git clone --recurse-submodules https://github.com/f5devcentral/f5xc-solutions`
- Enter repository directory with: `cd f5xc-gcp-cloud-ce`
- Obtain F5XC API certificate file from Console and save it to `cert` directory
- Pick and choose from below examples and add mandatory input data and copy data into file `main.tf.example`.
- Rename file __main.tf.example__ to __main.tf__ with: `rename main.tf.example main.tf`
- Change __versions.tf__ settings regarding Terraform state as needed. (local or remote state)
- Initialize with: `terraform init`
- Apply with: `terraform apply -auto-approve` or destroy with: `terraform destroy -auto-approve`

## F5XC GCP Cloud CE single NIC module new VPC usage example

````hcl
module "gcp_ce_multi_nic_new_vpc" {
  source                     = "./modules/f5xc/ce/gcp"
  is_sensitive               = false
  gcp_region                 = var.gcp_region
  machine_type               = var.machine_type
  network_name               = format("%s-%s-%s", var.project_prefix, var.project_name, var.project_suffix)
  ssh_username               = "centos"
  has_public_ip              = false
  machine_image              = var.machine_image
  instance_name              = format("%s-%s-%s", var.project_prefix, var.project_name, var.project_suffix)
  ssh_public_key             = file(var.ssh_public_key_file)
  machine_disk_size          = var.machine_disk_size
  fabric_subnet_inside       = var.fabric_subnet_inside
  fabric_subnet_outside      = var.fabric_subnet_outside
  host_localhost_public_name = "vip"
  f5xc_tenant                = var.f5xc_tenant
  f5xc_api_url               = var.f5xc_api_url
  f5xc_namespace             = var.f5xc_namespace
  f5xc_api_token             = var.f5xc_api_token
  f5xc_token_name            = format("%s-%s-%s", var.project_prefix, var.project_name, var.project_suffix)
  f5xc_fleet_label           = var.f5xc_fleet_label
  f5xc_cluster_latitude      = var.cluster_latitude
  f5xc_cluster_longitude     = var.cluster_longitude
  f5xc_ce_gateway_type       = "ingress_gateway"
  providers                  = {
    google   = google.default
    volterra = volterra.default
  }
}

output "gcp_ce_multi_nic_new_vpc" {
  value = module.gcp_ce_multi_nic_new_vpc.ce
}
````

## F5XC GCP Cloud CE Multi NIC new VPC module usage example

````hcl
module "gcp_ce" {
  source                     = "./modules/f5xc/ce/gcp"
  gcp_region                 = var.gcp_region
  machine_type               = var.machine_type
  network_name               = format("%s-%s-%s", var.project_prefix, var.project_name, var.project_suffix)
  ssh_username               = "centos"
  machine_image              = var.machine_image
  instance_name              = format("%s-%s-%s", var.project_prefix, var.project_name, var.project_suffix)
  ssh_public_key             = file(var.ssh_public_key_file)
  machine_disk_size          = var.machine_disk_size
  fabric_subnet_inside       = var.fabric_subnet_inside
  fabric_subnet_outside      = var.fabric_subnet_outside
  host_localhost_public_name = "vip"
  f5xc_tenant                = var.f5xc_tenant
  f5xc_api_url               = var.f5xc_api_url
  f5xc_namespace             = var.f5xc_namespace
  f5xc_api_token             = var.f5xc_api_token
  f5xc_token_name            = format("%s-%s-%s", var.project_prefix, var.project_name, var.project_suffix)
  f5xc_fleet_label           = var.f5xc_fleet_label
  f5xc_cluster_latitude      = var.cluster_latitude
  f5xc_cluster_longitude     = var.cluster_longitude
  f5xc_ce_gateway_type       = "ingress_egress_gateway"
  providers                  = {
    google   = google.default
    volterra = volterra.default
  }
}

output "ce" {
  value = module.gcp_ce.ce
}
````

## F5XC GCP Cloud CE Single NIC existing VPC module usage example

````hcl
module "gcp_ce_single_nic_existing_vpc" {
  source                         = "./modules/f5xc/ce/gcp"
  is_sensitive                   = false
  gcp_region                     = var.gcp_region
  machine_type                   = var.machine_type
  ssh_username                   = "centos"
  has_public_ip                  = false
  machine_image                  = var.machine_image["us"][var.f5xc_ce_gateway_type]
  instance_name                  = format("%s-%s-%s", var.project_prefix, var.project_name, var.project_suffix)
  ssh_public_key                 = file(var.ssh_public_key_file)
  machine_disk_size              = var.machine_disk_size
  host_localhost_public_name     = "vip"
  existing_fabric_subnet_outside = module.vpc_slo.subnets_ids[0]
  f5xc_tenant                    = var.f5xc_tenant
  f5xc_api_url                   = var.f5xc_api_url
  f5xc_namespace                 = var.f5xc_namespace
  f5xc_api_token                 = var.f5xc_api_token
  f5xc_token_name                = format("%s-%s-%s", var.project_prefix, var.project_name, var.project_suffix)
  f5xc_fleet_label               = var.f5xc_fleet_label
  f5xc_cluster_latitude          = var.cluster_latitude
  f5xc_cluster_longitude         = var.cluster_longitude
  f5xc_ce_gateway_type           = var.f5xc_ce_gateway_type
  providers                      = {
    google   = google.default
    volterra = volterra.default
  }
}

output "gcp_ce_single_nic_existing_vpc" {
  value = module.gcp_ce_multi_nic_existing_vpc.ce
}
````

## F5XC GCP Cloud CE Multi NIC existing VPC module usage example

````hcl
module "gcp_ce_multi_nic_existing_vpc" {
  source                         = "./modules/f5xc/ce/gcp"
  is_sensitive                   = false
  gcp_region                     = var.gcp_region
  machine_type                   = var.machine_type
  ssh_username                   = "centos"
  has_public_ip                  = false
  machine_image                  = var.machine_image["us"][var.f5xc_ce_gateway_type]
  instance_name                  = format("%s-%s-%s", var.project_prefix, var.project_name, var.project_suffix)
  ssh_public_key                 = file(var.ssh_public_key_file)
  machine_disk_size              = var.machine_disk_size
  host_localhost_public_name     = "vip"
  existing_fabric_subnet_outside = module.vpc_slo.subnets_ids[0]
  existing_fabric_subnet_inside  = module.vpc_sli.subnets_ids[0]
  f5xc_tenant                    = var.f5xc_tenant
  f5xc_api_url                   = var.f5xc_api_url
  f5xc_namespace                 = var.f5xc_namespace
  f5xc_api_token                 = var.f5xc_api_token
  f5xc_token_name                = format("%s-%s-%s", var.project_prefix, var.project_name, var.project_suffix)
  f5xc_fleet_label               = var.f5xc_fleet_label
  f5xc_cluster_latitude          = var.cluster_latitude
  f5xc_cluster_longitude         = var.cluster_longitude
  f5xc_ce_gateway_type           = var.f5xc_ce_gateway_type
  providers                      = {
    google   = google.default
    volterra = volterra.default
  }
}

output "gcp_ce_multi_nic_existing_vpc" {
  value = module.gcp_ce_multi_nic_existing_vpc.ce
}
````

## F5XC GCP Secure Cloud CE Multi NIC existing VPC and Google Cloud NAT module usage example

```hcl
module "vpc_slo" {
  source       = "terraform-google-modules/network/google"
  mtu          = 1460
  version      = "~> 6.0"
  project_id   = var.gcp_project_id
  network_name = "${var.project_prefix}-${var.project_name}-vpc-slo-${var.gcp_region}-${var.project_suffix}"
  subnets      = [
    {
      subnet_name   = "${var.project_prefix}-${var.project_name}-slo-${var.gcp_region}-${var.project_suffix}"
      subnet_ip     = "192.168.1.0/24"
      subnet_region = var.gcp_region
    }
  ]
}

module "vpc_sli" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 6.0"
  project_id   = var.gcp_project_id
  network_name = "${var.project_prefix}-${var.project_name}-vpc-sli-${var.gcp_region}-${var.project_suffix}"
  mtu          = 1460
  subnets      = [
    {
      subnet_name   = "${var.project_prefix}-${var.project_name}-sli-${var.gcp_region}-${var.project_suffix}"
      subnet_ip     = "192.168.2.0/24"
      subnet_region = var.gcp_region
    }
  ]
  delete_default_internet_gateway_routes = true
}

resource "google_compute_address" "nat" {
  count   = 1
  name    = "${module.vpc_slo.network_name}-${var.gcp_region}-nat-${count.index}"
  project = var.gcp_project_id
  region  = var.gcp_region
}

module "nat" {
  source                             = "terraform-google-modules/cloud-nat/google"
  version                            = "~> 2.0"
  project_id                         = var.gcp_project_id
  region                             = var.gcp_region
  router                             = "${var.project_prefix}-${var.project_name}-nat-router-${var.gcp_region}-${var.project_suffix}"
  create_router                      = true
  name                               = "${var.project_prefix}-${var.project_name}-nat-config-${var.gcp_region}-${var.project_suffix}"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  # nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.nat.*.self_link
  network                            = module.vpc_slo.network_name
}

module "gcp_secure_ce_multi_nic_existing_vpc" {
  source                   = "./modules/f5xc/ce/gcp"
  is_sensitive             = false
  gcp_region               = var.gcp_region
  project_name             = var.project_name
  machine_type             = var.machine_type
  ssh_username             = "centos"
  has_public_ip            = false
  machine_image            = var.machine_image["us"][var.f5xc_ce_gateway_type]
  instance_name            = format("%s-%s-%s", var.project_prefix, var.project_name, var.project_suffix)
  ssh_public_key           = file(var.ssh_public_key_file)
  machine_disk_size        = var.machine_disk_size
  existing_network_outside = module.vpc_slo
  existing_network_inside  = module.vpc_sli
  f5xc_tenant              = var.f5xc_tenant
  f5xc_api_url             = var.f5xc_api_url
  f5xc_namespace           = var.f5xc_namespace
  f5xc_api_token           = var.f5xc_api_token
  f5xc_token_name          = format("%s-%s-%s", var.project_prefix, var.project_name, var.project_suffix)
  f5xc_fleet_label         = var.f5xc_fleet_label
  f5xc_cluster_latitude    = var.cluster_latitude
  f5xc_cluster_longitude   = var.cluster_longitude
  f5xc_ce_gateway_type     = var.f5xc_ce_gateway_type
  f5xc_is_secure_cloud_ce  = true
  providers                = {
    google   = google.default
    volterra = volterra.default
  }
}

output "gcp_ce_multi_nic_existing_vpc" {
  value = module.gcp_secure_ce_multi_nic_existing_vpc.ce
}
```

## F5XC GCP Cloud CE Multi NIC existing VPC and Google Cloud NAT module usage example

```hcl
variable "f5xc_ves_images_base_url" {
  type    = string
  default = "https://storage.googleapis.com/ves-images"
}

variable "machine_image_name" {
  type    = string
  default = "centos7-atomic-20220721105-multi-voltmesh-custom"
}

variable "machine_image_base" {
  type = object({
    ingress_gateway        = string
    ingress_egress_gateway = string
  })
  default = {
    ingress_gateway        = "centos7-atomic-20220721105-single-voltmesh"
    ingress_egress_gateway = "centos7-atomic-20220721105-multi-voltmesh"
  }
}

resource "google_compute_image" "f5xc_ce" {
  name    = local.f5xc_image_name
  project = var.gcp_project_id
  family  = var.machine_image_family

  dynamic "guest_os_features" {
    for_each = var.f5xc_ce_gateway_type == "ingress_egress_gateway" ? [1] : []
    content {
      type = "MULTI_IP_SUBNET"
    }
  }
  raw_disk {
    source = format("%s/%s.tar.gz", var.f5xc_ves_images_base_url, var.machine_image_base[var.f5xc_ce_gateway_type])
  }
}

module "vpc_slo" {
  source       = "terraform-google-modules/network/google"
  mtu          = 1460
  version      = "~> 6.0"
  project_id   = var.gcp_project_id
  network_name = "${var.project_prefix}-${var.project_name}-vpc-slo-${var.gcp_region}-${var.project_suffix}"
  subnets      = [
    {
      subnet_name   = "${var.project_prefix}-${var.project_name}-slo-${var.gcp_region}-${var.project_suffix}"
      subnet_ip     = "192.168.1.0/24"
      subnet_region = var.gcp_region
    }
  ]
}

module "vpc_sli" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 6.0"
  project_id   = var.gcp_project_id
  network_name = "${var.project_prefix}-${var.project_name}-vpc-sli-${var.gcp_region}-${var.project_suffix}"
  mtu          = 1460
  subnets      = [
    {
      subnet_name   = "${var.project_prefix}-${var.project_name}-sli-${var.gcp_region}-${var.project_suffix}"
      subnet_ip     = "192.168.2.0/24"
      subnet_region = var.gcp_region
    }
  ]
  delete_default_internet_gateway_routes = true
}

resource "google_compute_address" "nat" {
  count   = 1
  name    = "${module.vpc_slo.network_name}-${var.gcp_region}-nat-${count.index}"
  project = var.gcp_project_id
  region  = var.gcp_region
}

module "nat" {
  source                             = "terraform-google-modules/cloud-nat/google"
  version                            = "~> 2.0"
  project_id                         = var.gcp_project_id
  region                             = var.gcp_region
  router                             = "${var.project_prefix}-${var.project_name}-nat-router-${var.gcp_region}-${var.project_suffix}"
  create_router                      = true
  name                               = "${var.project_prefix}-${var.project_name}-nat-config-${var.gcp_region}-${var.project_suffix}"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  # nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.nat.*.self_link
  network                            = module.vpc_slo.network_name
}

module "gcp_secure_ce_single_node_multi_nic_existing_vpc" {
  source                   = "./modules/f5xc/ce/gcp"
  owner                    = var.owner
  gcp_region               = var.gcp_region
  ssh_username             = "centos"
  instance_type            = var.machine_type
  has_public_ip            = false
  ssh_public_key           = file(var.ssh_public_key_file)
  instance_image           = google_compute_image.f5xc_ce.name
  instance_disk_size       = var.machine_disk_size
  existing_network_inside  = module.vpc_sli
  existing_network_outside = module.vpc_slo
  f5xc_tenant              = var.f5xc_tenant
  f5xc_api_url             = var.f5xc_api_url
  f5xc_namespace           = var.f5xc_namespace
  f5xc_api_token           = var.f5xc_api_token
  f5xc_token_name          = format("%s-%s-%s", var.project_prefix, var.project_name, var.project_suffix)
  f5xc_cluster_name        = format("%s-%s-%s", var.project_prefix, var.project_name, var.project_suffix)
  f5xc_ce_slo_subnet       = ""
  f5xc_cluster_labels      = {}
  f5xc_ce_nodes            = {
    node0 = {
      az = format("%s-b", var.gcp_region)
    }
  }
  f5xc_ce_gateway_type    = "ingress_egress_gateway"
  f5xc_cluster_latitude   = var.cluster_latitude
  f5xc_cluster_longitude  = var.cluster_longitude
  f5xc_is_secure_cloud_ce = true

  providers = {
    google   = google.default
    volterra = volterra.default
  }
}

output "gcp_secure_ce_single_node_multi_nic_existing_vpc" {
  value = module.gcp_secure_ce_single_node_multi_nic_existing_vpc.ce
}
```

## F5XC GCP Cloud CE Single NIC existing VPC and SLO enable secure SGs module usage example

```hcl
module "gcp_secure_cloud_ce_single_provided_prefixes__node_single_nic_new_vpc_" {
  source                       = "./modules/f5xc/ce/gcp"
  owner                        = var.owner
  gcp_region                   = var.gcp_region
  ssh_username                 = "centos"
  ssh_public_key               = file(var.ssh_public_key_file)
  instance_image               = var.machine_image_base["ingress_gateway"]
  f5xc_tenant                  = var.f5xc_tenant
  f5xc_api_url                 = var.f5xc_api_url
  f5xc_namespace               = var.f5xc_namespace
  f5xc_api_token               = var.f5xc_api_token
  f5xc_token_name              = format("%s-%s-%s", var.project_prefix, var.project_name, var.project_suffix)
  f5xc_cluster_name            = format("%s-%s-%s", var.project_prefix, var.project_name, var.project_suffix)
  f5xc_ce_slo_subnet           = "10.15.250.0/24"
  f5xc_ce_gateway_type         = "ingress_gateway"
  f5xc_ip_ranges_Asia_TCP      = var.f5xc_ip_ranges_Asia_TCP
  f5xc_ip_ranges_Asia_UDP      = var.f5xc_ip_ranges_Asia_UDP
  f5xc_ce_egress_ip_ranges     = var.f5xc_ce_egress_ip_ranges
  f5xc_ip_ranges_Europe_TCP    = var.f5xc_ip_ranges_Europe_TCP
  f5xc_ip_ranges_Europe_UDP    = var.f5xc_ip_ranges_Europe_UDP
  f5xc_ip_ranges_Americas_TCP  = var.f5xc_ip_ranges_Americas_TCP
  f5xc_ip_ranges_Americas_UDP  = var.f5xc_ip_ranges_Americas_UDP
  f5xc_ce_slo_enable_secure_sg = true
  f5xc_ce_nodes                = {
    node0 = {
      az = format("%s-b", var.gcp_region)
    }
  }
  providers = {
    google   = google.default
    volterra = volterra.default
  }
}

output "gcp_secure_cloud_ce_single_provided_prefixes__node_single_nic_new_vpc_" {
  value = module.gcp_secure_cloud_ce_single_provided_prefixes__node_single_nic_new_vpc_.ce
}
```