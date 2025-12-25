terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "aws" {
  region = var.aws_region
}


data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Get subnet details to filter by AZ
data "aws_subnet" "default" {
  for_each = toset(data.aws_subnets.default_subnets.ids)
  id       = each.value
}

# Create a map of AZ to subnet (one subnet per AZ for ALB)
locals {
  alb_subnets = [
    for az, subnets in {
      for s in data.aws_subnet.default :
      s.availability_zone => s.id...
    } : subnets[0]
  ]
}

