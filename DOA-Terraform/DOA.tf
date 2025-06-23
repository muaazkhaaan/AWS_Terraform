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
    cidr_block = "10.10.0.0/20"
    enable_dns_hostnames = false
    enable_dns_support = true

    tags = {
    Name = "VPC",
    managed-by = "Terraform",
    deployed-by = "Muaaz"
    }
}

resource "aws_subnet" "public_1" {
    vpc_id = aws_vpc.this.id
    cidr_block = "10.10.10.0/24"
    map_public_ip_on_launch = true

    tags = {
    Name = "Subnet1",
    managed-by = "Terraform",
    deployed-by = "Muaaz"
    }
}

resource "aws_subnet" "public_2" {
    vpc_id = aws_vpc.this.id
    cidr_block = "10.10.11.0/24"
    map_public_ip_on_launch = true

    tags = {
    Name = "Subnet2",
    managed-by = "Terraform",
    deployed-by = "Muaaz"
    }
}