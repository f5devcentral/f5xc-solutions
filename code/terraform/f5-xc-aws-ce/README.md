# AWS CLOUD CE

Terraform to create F5XC AWS cloud CE

## Usage

- Clone this repo with: `git clone --recurse-submodules https://github.com/devcentral/f5xc-solutions`
- Enter repository directory with: `cd aws cloud ce`
- Obtain F5XC API certificate file from Console and save it to `cert` directory
- Pick and choose from below examples and add mandatory input data and copy data into file `main.py.example`.
- Rename file __main.tf.example__ to __main.tf__ with: `rename main.py.example main.py`
- Initialize with: `terraform init`
- Apply with: `terraform apply -auto-approve` or destroy with: `terraform destroy -auto-approve`

## AWS Cloud CE common module usage example data

```hcl
variable "project_prefix" {
  type        = string
  description = "prefix string put in front of string"
  default     = "f5xc"
}

variable "project_suffix" {
  type        = string
  description = "prefix string put at the end of string"
  default     = "01"
}

variable "f5xc_api_p12_file" {
  type = string
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_token" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_namespace" {
  type    = string
  default = "system"
}

variable "f5xc_aws_cred" {
  type    = string
  default = "user-aws-01"
}

variable "f5xc_aws_region" {
  type    = string
  default = "us-west-2"
}

variable "f5xc_aws_availability_zone" {
  type    = string
  default = "a"
}

variable "owner" {
  type    = string
  default = "user@f5.com"
}

variable "ssh_public_key_file" {
  type = string
}

locals {
  aws_availability_zone = format("%s%s", var.f5xc_aws_region, var.f5xc_aws_availability_zone)
  custom_tags           = {
    Owner        = var.owner
    f5xc-tenant  = var.f5xc_tenant
    f5xc-feature = "${var.project_prefix}-aws-vpc-site"
  }
}

provider "volterra" {
  api_p12_file = var.f5xc_api_p12_file
  url          = var.f5xc_api_url
  alias        = "default"
}

provider "aws" {
  region = var.f5xc_aws_region
  alias  = "default"
}
```

## AWS Cloud CE Single Node Single NIC module usage example

```hcl
module "aws_ce" {
  source                = "./modules/f5xc/ce/aws"
  is_sensitive          = false
  has_public_ip         = true
  aws_vpc_cidr_block    = "192.168.0.0/20"
  f5xc_api_token        = var.f5xc_api_token
  f5xc_api_url          = var.f5xc_api_url
  f5xc_aws_vpc_az_nodes = {
    node0 = {
      f5xc_aws_vpc_slo_subnet = "192.168.0.0/26",
      f5xc_aws_vpc_az_name    = local.aws_availability_zone
    }
  }
  f5xc_ce_gateway_type   = "ingress_gateway"
  f5xc_namespace         = var.f5xc_namespace
  f5xc_tenant            = var.f5xc_tenant
  f5xc_token_name        = format("%s-aws-ce-test-%s", var.project_prefix, var.project_suffix)
  f5xc_aws_region        = var.f5xc_aws_region
  f5xc_cluster_latitude  = -73.935242
  f5xc_cluster_longitude = 40.730610
  f5xc_cluster_name      = format("%s-aws-ce-test-%s", var.project_prefix, var.project_suffix)
  f5xc_cluster_labels    = { "ves.io/fleet" : format("%s-aws-ce-test-%s", var.project_prefix, var.project_suffix) }
  owner_tag              = var.owner
  public_name            = "vip"
  ssh_public_key         = file(var.ssh_public_key_file)
  providers              = {
    aws      = aws.default
    volterra = volterra.default
  }
}

output "aws_ce" {
  value = module.aws_ce
}
````

## AWS Cloud CE Single Node Multi NIC module usage example

```hcl
module "aws_ce" {
  source                = "./modules/f5xc/ce/aws"
  is_sensitive          = false
  has_public_ip         = true
  aws_vpc_cidr_block    = "192.168.0.0/20"
  f5xc_api_token        = var.f5xc_api_token
  f5xc_api_url          = var.f5xc_api_url
  f5xc_aws_vpc_az_nodes = {
    node0 = {
      f5xc_aws_vpc_slo_subnet = "192.168.0.0/26",
      f5xc_aws_vpc_sli_subnet = "192.168.0.64/26",
      f5xc_aws_vpc_az_name    = local.aws_availability_zone
    }
  }
  f5xc_ce_gateway_type   = "ingress_egress_gateway"
  f5xc_namespace         = var.f5xc_namespace
  f5xc_tenant            = var.f5xc_tenant
  f5xc_token_name        = format("%s-aws-ce-test-%s", var.project_prefix, var.project_suffix)
  f5xc_aws_region        = var.f5xc_aws_region
  f5xc_cluster_latitude  = -73.935242
  f5xc_cluster_longitude = 40.730610
  f5xc_cluster_name      = format("%s-aws-ce-test-%s", var.project_prefix, var.project_suffix)
  f5xc_cluster_labels    = { "ves.io/fleet" : format("%s-aws-ce-test-%s", var.project_prefix, var.project_suffix) }
  owner_tag              = var.owner
  public_name            = "vip"
  ssh_public_key         = file(var.ssh_public_key_file)
  providers              = {
    aws      = aws.default
    volterra = volterra.default
  }
}

output "aws_ce" {
  value = module.aws_ce
}
```

## AWS Cloud CE Multi Node Single NIC different AZ module usage example

```hcl
module "aws_ce" {
  source                = "./modules/f5xc/ce/aws"
  owner_tag             = var.owner
  has_public_ip         = true
  is_sensitive          = false
  aws_vpc_cidr_block    = "192.168.0.0/20"
  f5xc_api_token        = var.f5xc_api_token
  f5xc_api_url          = var.f5xc_api_url
  f5xc_aws_vpc_az_nodes = {
    node0 = {
      f5xc_aws_vpc_slo_subnet = "192.168.0.0/26",
      f5xc_aws_vpc_az_name    = format("%s%s", var.f5xc_aws_region, "a")
    },
    node1 = {
      f5xc_aws_vpc_slo_subnet = "192.168.0.64/26",
      f5xc_aws_vpc_az_name    = format("%s%s", var.f5xc_aws_region, "b")
    },
    node2 = {
      f5xc_aws_vpc_slo_subnet = "192.168.0.128/26",
      f5xc_aws_vpc_az_name    = format("%s%s", var.f5xc_aws_region, "c")
    }
  }
  f5xc_ce_gateway_type   = "ingress_gateway"
  f5xc_namespace         = var.f5xc_namespace
  f5xc_tenant            = var.f5xc_tenant
  f5xc_token_name        = format("%s-aws-ce-test-%s", var.project_prefix, var.project_suffix)
  f5xc_aws_region        = var.f5xc_aws_region
  f5xc_cluster_latitude  = -73.935242
  f5xc_cluster_longitude = 40.730610
  f5xc_cluster_name      = format("%s-aws-ce-test-%s", var.project_prefix, var.project_suffix)
  f5xc_cluster_labels    = { "ves.io/fleet" : format("%s-aws-ce-test-%s", var.project_prefix, var.project_suffix) }
  ssh_public_key         = file(var.ssh_public_key_file)
  providers              = {
    aws      = aws.default
    volterra = volterra.default
  }
}

output "aws_ce" {
  value = module.aws_ce
}
```

## AWS Cloud CE Multi Node Multi NIC different AZ module usage example

```hcl
module "aws_ce" {
  source                = "./modules/f5xc/ce/aws"
  owner_tag             = var.owner
  has_public_ip         = true
  is_sensitive          = false
  aws_vpc_cidr_block    = "192.168.0.0/20"
  f5xc_api_token        = var.f5xc_api_token
  f5xc_api_url          = var.f5xc_api_url
  f5xc_aws_vpc_az_nodes = {
    node0 = {
      f5xc_aws_vpc_slo_subnet = "192.168.0.0/26",
      f5xc_aws_vpc_sli_subnet = "192.168.1.0/26",
      f5xc_aws_vpc_az_name    = format("%s%s", var.f5xc_aws_region, "a")
    },
    node1 = {
      f5xc_aws_vpc_slo_subnet = "192.168.0.64/26",
      f5xc_aws_vpc_sli_subnet = "192.168.1.64/26",
      f5xc_aws_vpc_az_name    = format("%s%s", var.f5xc_aws_region, "b")
    },
    node2 = {
      f5xc_aws_vpc_slo_subnet = "192.168.0.128/26",
      f5xc_aws_vpc_sli_subnet = "192.168.1.128/26",
      f5xc_aws_vpc_az_name    = format("%s%s", var.f5xc_aws_region, "c")
    }
  }
  f5xc_ce_gateway_type   = "ingress_egress_gateway"
  f5xc_namespace         = var.f5xc_namespace
  f5xc_tenant            = var.f5xc_tenant
  f5xc_token_name        = format("%s-aws-ce-test-%s", var.project_prefix, var.project_suffix)
  f5xc_aws_region        = var.f5xc_aws_region
  f5xc_cluster_latitude  = -73.935242
  f5xc_cluster_longitude = 40.730610
  f5xc_cluster_name      = format("%s-aws-ce-test-%s", var.project_prefix, var.project_suffix)
  f5xc_cluster_labels    = { "ves.io/fleet" : format("%s-aws-ce-test-%s", var.project_prefix, var.project_suffix) }
  ssh_public_key         = file(var.ssh_public_key_file)
  providers              = {
    aws      = aws.default
    volterra = volterra.default
  }
}

output "aws_ce" {
  value = module.aws_ce
}
```

## AWS Secure Cloud CE Single Node Single NIC module usage example

```hcl
module "vpc__multi_node_single_nic_existing_vpc_existing_subnet" {
  source             = "./modules/aws/vpc"
  aws_owner          = var.owner
  aws_region         = var.f5xc_aws_region
  aws_az_name        = local.aws_availability_zone
  aws_vpc_name       = format("%s-vpc-sn-snic-exist-vpc-and-snet-%s", var.project_prefix, var.project_suffix)
  aws_vpc_cidr_block = "172.16.44.0/22"
  custom_tags        = local.custom_tags
  providers          = {
    aws = aws.default
  }
}

module "f5xc_aws_secure_ce_single_node_single_nic_existing_vpc" {
  source                = "./modules/f5xc/ce/aws"
  owner_tag             = var.owner
  is_sensitive          = false
  has_public_ip         = false
  create_new_aws_vpc    = false
  f5xc_tenant           = var.f5xc_tenant
  f5xc_api_url          = var.f5xc_api_url
  f5xc_api_token        = var.f5xc_api_token
  f5xc_namespace        = var.f5xc_namespace
  f5xc_token_name       = format("%s-secure-cloud-ce-test-%s", var.project_prefix, var.project_suffix)
  f5xc_aws_region       = var.f5xc_aws_region
  f5xc_cluster_name     = format("%s-aws-ce-test-%s", var.project_prefix, var.project_suffix)
  f5xc_cluster_labels   = { "ves.io/fleet" : format("%s-aws-ce-test-%s", var.project_prefix, var.project_suffix) }
  f5xc_ce_gateway_type  = "ingress_gateway"
  f5xc_aws_vpc_az_nodes = {
    node0 = {
      f5xc_aws_vpc_slo_subnet    = "172.16.44.0/27",
      f5xc_aws_vpc_az_name       = format("%s%s", var.f5xc_aws_region, "a"),
      f5xc_aws_vpc_nat_gw_subnet = "172.16.44.32/27",
    }
  }
  f5xc_cluster_latitude                = -73.935242
  f5xc_cluster_longitude               = 40.730610
  f5xc_is_secure_cloud_ce              = true
  aws_existing_vpc_id                  = module.vpc__multi_node_single_nic_existing_vpc_existing_subnet.aws_vpc["id"]
  aws_security_group_rules_slo_egress  = []
  aws_security_group_rules_slo_ingress = []
  aws_security_group_rules_sli_egress  = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
    },
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = ["192.168.0.0/16"]
    },
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = ["172.16.0.0/12"]
    },
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "udp"
      cidr_blocks = ["10.0.0.0/8"]
    },
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "udp"
      cidr_blocks = ["192.168.0.0/16"]
    },
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "udp"
      cidr_blocks = ["172.16.0.0/12"]
    }
  ]
  ssh_public_key = file(var.ssh_public_key_file)
  providers      = {
    aws      = aws.default
    volterra = volterra.default
  }
}

output "f5xc_aws_secure_ce_single_node_single_nic_existing_vpc" {
  value = module.f5xc_aws_secure_ce_single_node_single_nic_existing_vpc
}
```

## AWS Secure Cloud CE Multi Node Multi NIC different AZ module usage example

```hcl
module "vpc__multi_node_single_nic_existing_vpc_existing_subnet" {
  source             = "./modules/aws/vpc"
  aws_owner          = var.owner
  aws_region         = var.f5xc_aws_region
  aws_az_name        = local.aws_availability_zone
  aws_vpc_name       = format("%s-vpc-sn-snic-exist-vpc-and-snet-%s", var.project_prefix, var.project_suffix)
  aws_vpc_cidr_block = "172.16.44.0/22"
  custom_tags        = local.custom_tags
  providers          = {
    aws = aws.default
  }
}

module "f5xc_aws_secure_ce_multi_node_single_nic_existing_vpc" {
  source                = "./modules/f5xc/ce/aws"
  owner_tag             = var.owner
  is_sensitive          = false
  has_public_ip         = false
  create_new_aws_vpc    = false
  f5xc_tenant           = var.f5xc_tenant
  f5xc_api_url          = var.f5xc_api_url
  f5xc_api_token        = var.f5xc_api_token
  f5xc_namespace        = var.f5xc_namespace
  f5xc_token_name       = format("%s-aws-ce-test-%s", var.project_prefix, var.project_suffix)
  f5xc_aws_region       = var.f5xc_aws_region
  f5xc_cluster_name     = format("%s-aws-ce-test-%s", var.project_prefix, var.project_suffix)
  f5xc_cluster_labels   = { "ves.io/fleet" : format("%s-aws-ce-test-%s", var.project_prefix, var.project_suffix) }
  f5xc_ce_gateway_type  = "ingress_gateway"
  f5xc_aws_vpc_az_nodes = {
    node0 = {
      f5xc_aws_vpc_slo_subnet    = "172.16.44.0/27",
      f5xc_aws_vpc_az_name       = format("%s%s", var.f5xc_aws_region, "a"),
      f5xc_aws_vpc_nat_gw_subnet = "172.16.44.32/27",
    },
    node1 = {
      f5xc_aws_vpc_slo_subnet    = "172.16.44.64/27",
      f5xc_aws_vpc_az_name       = format("%s%s", var.f5xc_aws_region, "b"),
      f5xc_aws_vpc_nat_gw_subnet = "172.16.44.96/27",
    },
    node2 = {
      f5xc_aws_vpc_slo_subnet    = "172.16.44.128/27",
      f5xc_aws_vpc_az_name       = format("%s%s", var.f5xc_aws_region, "c"),
      f5xc_aws_vpc_nat_gw_subnet = "172.16.44.160/27",
    }
  }
  f5xc_cluster_latitude                = -73.935242
  f5xc_cluster_longitude               = 40.730610
  f5xc_is_secure_cloud_ce              = true
  aws_existing_vpc_id                  = module.vpc__multi_node_single_nic_existing_vpc_existing_subnet.aws_vpc["id"]
  aws_security_group_rules_slo_egress  = []
  aws_security_group_rules_slo_ingress = []
  aws_security_group_rules_sli_egress  = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
    },
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = ["192.168.0.0/16"]
    },
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = ["172.16.0.0/12"]
    },
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "udp"
      cidr_blocks = ["10.0.0.0/8"]
    },
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "udp"
      cidr_blocks = ["192.168.0.0/16"]
    },
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "udp"
      cidr_blocks = ["172.16.0.0/12"]
    }
  ]
  ssh_public_key = file(var.ssh_public_key_file)
  providers      = {
    aws      = aws.default
    volterra = volterra.default
  }
}

output "f5xc_aws_secure_ce_multi_node_single_nic_existing_vpc" {
  value = module.f5xc_aws_secure_ce_multi_node_single_nic_existing_vpc
}
```