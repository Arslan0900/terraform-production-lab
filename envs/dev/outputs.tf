output "environment" {
  description = "Environment name"
  value       = var.environment
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "Public subnet ID"
  value       = module.vpc.public_subnet_id
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = module.ec2_web.instance_id
}

output "website_url" {
  description = "Website URL"
  value       = module.ec2_web.website_url
}

output "health_url" {
  description = "Health check URL"
  value       = module.ec2_web.health_url
}
