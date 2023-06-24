module "create_ec2_from_codebase" {
    source = "git::https://github.com/techbleat/codebase.git"
    bucket = var.our_bucket
    key =  var.our_key
    sg_name = var.our_sg_name
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  backend "s3" {
    bucket = var.our_bucket
    key    = var.our_key
    region = "eu-west-1"
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-1"
}

variable our_key {}
variable our_bucket {}
variable our_sg_name {}