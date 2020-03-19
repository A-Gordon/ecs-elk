provider "aws" {
  version = "~> 2.0"
  region  = var.region
}

locals {
  name        = "${var.tenant}-${var.environment}"
  environment = var.environment
  # This is the convention we use to know what belongs to each other
  ec2_resources_name = "${local.name}"
}

resource "aws_key_pair" "key" {
  key_name   = local.name
  public_key = var.ssh_public_key
}



