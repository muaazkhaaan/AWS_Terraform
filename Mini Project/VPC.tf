terraform {
    required_version =">= 1"
    required_providers {
    aws = {
        source = "hashicorp/aws"
        version = ">= 6.0"
    }
    }
}

provider "aws" {
    region = "eu-west-2"
}

resource "aws_vpc" "this" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = false
    enable_dns_support = true

    tags = {
    Name = "VPC",
    managed-by = "Terraform",
    deployed-by = var.deployed_by
    }
}

resource "aws_subnet" "public_1" {
    vpc_id = aws_vpc.this.id
    cidr_block = var.subnet_1_cidr
    map_public_ip_on_launch = true

    tags = {
    Name = "Subnet1",
    managed-by = "Terraform",
    deployed-by = var.deployed_by
    }
}

resource "aws_subnet" "public_2" {
    vpc_id = aws_vpc.this.id
    cidr_block = var.subnet_2_cidr
    map_public_ip_on_launch = true

    tags = {
    Name = "Subnet2",
    managed-by = "Terraform",
    deployed-by = var.deployed_by
    }
}

variable "vpc_cidr" {
    type        = string
    default     = "10.10.0.0/20"
    description = "CIDR block for the VPC"

    validation {
        condition     = length(var.vpc_cidr) >= 9 && length(var.vpc_cidr) <= 18
        error_message = "VPC CIDR must be between 9 and 18 characters."
    }

    validation {
        condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", var.vpc_cidr))
        error_message = "Must be a valid IP CIDR range of the form x.x.x.x/x."
    }
}

variable "subnet_1_cidr" {
    type = string
    default = "10.10.10.0/24"
    description = "CIDR block for Subnet 1"
}

variable "subnet_2_cidr" {
    type = string
    default = "10.10.11.0/24"
    description = "CIDR block for Subnet 2"
}

variable "deployed_by" {
    type = string
    default = "Muaaz"
    description = "Author"
}

output "vpc_id" {
    value = aws_vpc.this.id
    description = "value of the VPC ID"
}

output "subnet_ids" {
    value = [aws_subnet.public_1.id, aws_subnet.public_2.id]
    description = "List of subnet IDs"
}

variable "spoke_names" {
  description = "Names of spoke environments"
  type        = list(string)
  default     = ["Trust1", "Trust2"]
}

locals {
  spoke_cidrs = {
    for name in var.spoke_names :
    name => cidrsubnet("10.20.0.0/16", 4, index(var.spoke_names, name))
  }
}

resource "aws_vpc" "spoke" {
  for_each   = local.spoke_cidrs
  cidr_block = each.value
  tags = {
    Name         = each.key
    environment  = "dev"
    managed-by   = "Terraform"
    deployed-by  = var.deployed_by
  }
}
