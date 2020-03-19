resource "aws_security_group" "alb_ingress" {
  name        = "${local.name}-alb-ingress"
  description = "Allow alb inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTP from ALL"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Logstash from ALL"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Kibana from ALL"
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Elasticsearch from ALL"
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Terraform   = "true"
    Name        = local.name
    Environment = var.environment
    Tenant      = var.tenant
  }

}

resource "aws_lb" "ecs" {
  name               = "${local.name}-ecs"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.alb_ingress.id}"]
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = true

#   access_logs {
#     bucket  = "${aws_s3_bucket.lb_logs.bucket}"
#     prefix  = "test-lb"
#     enabled = true
#   }

  tags = {
    Terraform   = "true"
    Name        = local.name
    Environment = var.environment
    Tenant      = var.tenant
  }
}

resource "aws_lb_target_group" "apache" {
  name     = "${local.name}-apache"
  port     = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_lb_target_group" "elasticsearch" {
  name     = "${local.name}-elasticsearch"
  port     = 9200
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = module.vpc.vpc_id
  health_check {
      matcher = "200"
  }
}

resource "aws_lb_target_group" "kibana" {
  name     = "${local.name}-kibana"
  port     = 5601
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = module.vpc.vpc_id
  health_check {
      matcher = "302"
  }
}

resource "aws_lb_target_group" "logstash" {
  name     = "${local.name}-logstash"
  port     = 5000
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = module.vpc.vpc_id
  health_check {
      port = 9600
  }
}

resource "aws_lb_listener" "apache" {
  load_balancer_arn = "${aws_lb.ecs.arn}"
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.apache.arn}"
  }
}

resource "aws_lb_listener" "elasticsearch" {
  load_balancer_arn = "${aws_lb.ecs.arn}"
  port              = "9200"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.elasticsearch.arn}"
  }
}

resource "aws_lb_listener" "kibana" {
  load_balancer_arn = "${aws_lb.ecs.arn}"
  port              = "5601"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.kibana.arn}"
  }
}

resource "aws_lb_listener" "logstash" {
  load_balancer_arn = "${aws_lb.ecs.arn}"
  port              = "5000"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.logstash.arn}"
  }
}

resource "aws_route53_record" "elasticsearch" {
  zone_id = "${aws_route53_zone.private_aws.zone_id}"
  name    = "elasticsearch"
  type    = "A"
  alias {
    name                   = "${aws_lb.ecs.dns_name}"
    zone_id                = "${aws_lb.ecs.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "kibana" {
  zone_id = "${aws_route53_zone.private_aws.zone_id}"
  name    = "kibana"
  type    = "A"
  alias {
    name                   = "${aws_lb.ecs.dns_name}"
    zone_id                = "${aws_lb.ecs.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "logstash" {
  zone_id = "${aws_route53_zone.private_aws.zone_id}"
  name    = "logstash"
  type    = "A"
  alias {
    name                   = "${aws_lb.ecs.dns_name}"
    zone_id                = "${aws_lb.ecs.zone_id}"
    evaluate_target_health = true
  }
}


output "aws_lb_ecs_arn" {
  description = "ARN of the ecs LB "
  value       = aws_lb.ecs.arn
}

output "aws_lb_ecs_dns" {
  description = "DNS of the ecs LB "
  value       = aws_lb.ecs.dns_name
}

output "aws_lb_target_group_apache" {
  description = "ARN of the apache LB target group"
  value       = aws_lb_target_group.apache.arn
}

output "aws_lb_target_group_elasticsearch" {
  description = "ARN of the elasticsearch LB target group"
  value       = aws_lb_target_group.elasticsearch.arn
}

output "aws_lb_target_group_logstash" {
  description = "ARN of the logstash LB target group"
  value       = aws_lb_target_group.logstash.arn
}

output "aws_lb_target_group_kibana" {
  description = "ARN of the kibana LB target group"
  value       = aws_lb_target_group.kibana.arn
}