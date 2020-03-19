resource "aws_ecs_capacity_provider" "test" {
  name = join("-", [local.name, "asg", module.this.this_autoscaling_group_name])

  auto_scaling_group_provider {
    auto_scaling_group_arn         = module.this.this_autoscaling_group_arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = 1000
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 10
    }
  }
}

resource "aws_ecs_cluster" "this" {
  name = local.name
  capacity_providers = [join("-", [local.name, "asg", module.this.this_autoscaling_group_name])]
  default_capacity_provider_strategy {
      capacity_provider = join("-", [local.name, "asg", module.this.this_autoscaling_group_name])
      weight            = "100"
    }
}

module "ecs_ecs-instance-profile" {
  source  = "terraform-aws-modules/ecs/aws//modules/ecs-instance-profile"
  name    = local.name
}


# resource "aws_iam_role" "elastic" {
#   name = "${local.name}-elastic-discovery

# assume_role_policy = <<EOF
#   {
#     "Version": "2012-10-17",
#     "Statement": [
#       {
#         "Action": "sts:AssumeRole",
#         "Principal": {
#           "Service": "ecs-tasks.amazonaws.com"
#         },
#         "Effect": "Allow",
#         "Sid": ""
#       }
#     ]
#   }
# EOF
# }

resource "aws_iam_role" "elastic" {
  name = "${local.name}-elastic"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_policy_attachment" "elastic-attach" {
  name       = "${local.name}-elastic-attachment"
  roles      = ["${aws_iam_role.elastic.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

output "aws_iam_role_elastic_arn" {
  description = "ARN of the elastic iam role"
  value       = aws_iam_role.elastic.arn
}
