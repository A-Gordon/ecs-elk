module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.name
  cidr = "10.0.0.0/16"

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_dns_hostnames = true
  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Name        = local.name
    Environment = var.environment
    Tenant      = var.tenant
  }
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "vpc_public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}