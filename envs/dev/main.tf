terraform {
  required_version = ">= 1.6.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "../../modules/vpc"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = var.availability_zone
}

module "ec2_web" {
  source = "../../modules/ec2-web"

  project_name     = var.project_name
  environment      = var.environment
  instance_type    = var.instance_type
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_id

  depends_on = [module.vpc]
}
