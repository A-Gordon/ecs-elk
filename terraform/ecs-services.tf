# data "aws_ecs_task_definition" "apache" {
#   task_definition = "apache"
# }

# # filter {
# #     name   = "name"
# #     values = ["amzn-ami-*-amazon-ecs-optimized"]
# #   }

# resource "aws_ecs_service" "apache" {
#   name            = "apache"
#   cluster         = "andy-test"
#   task_definition = "${data.aws_ecs_task_definition.apache.family}"
#   desired_count   = 1
#   network_configuration {
#       subnets = module.vpc.public_subnets
#   }
#   iam_role        = "${aws_iam_role.foo.arn}"
#   depends_on      = ["aws_iam_role_policy.foo"]

#   ordered_placement_strategy {
#     type  = "binpack"
#     field = "cpu"
#   }

#   load_balancer {
#     target_group_arn = "${aws_lb_target_group.foo.arn}"
#     container_name   = "mongo"
#     container_port   = 8080
#   }

#   placement_constraints {
#     type       = "memberOf"
#     expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
#   }
# }