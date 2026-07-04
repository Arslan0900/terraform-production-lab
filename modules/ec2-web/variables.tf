variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name like dev or prod"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for security group"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID for EC2"
  type        = string
}
