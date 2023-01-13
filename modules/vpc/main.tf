terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.15.0"

  name = "${var.project}-${var.environment}"
  cidr = "10.0.0.0/18"

  azs              = ["${var.region}a", "${var.region}b", "${var.region}c"]
  public_subnets   = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  private_subnets  = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
  database_subnets = ["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]

  create_database_subnet_group = true
  enable_nat_gateway           = true
  single_nat_gateway           = true
  map_public_ip_on_launch      = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  manage_default_security_group  = true
  default_security_group_ingress = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Public access to API gateway endpoint"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  default_security_group_egress  = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      description = "Public access to outside world"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  enable_flow_log = false

  tags = var.tags
}
