resource "aws_route53_zone" "private_aws" {
  name = "aws."
  vpc {
    vpc_id = module.vpc.vpc_id
  }
}

output "aws_route53_zone_private_aws_zone_id" {
  description = ""
  value       = "${aws_route53_zone.private_aws.zone_id}"
}