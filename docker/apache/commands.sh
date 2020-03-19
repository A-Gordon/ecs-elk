#!/bin/bash

#Task
# ecs-cli compose --project-name apache --region eu-west-1 --cluster andy-test --ecs-params ./ecs-params.yml --verbose up

# #Service
ecs-cli compose --region eu-west-1 \
--cluster andy-test \
--ecs-params ./ecs-params.yml \
service up \
--enable-service-discovery \
--vpc ${AWS_VPC_ID} \
--private-dns-namespace local \
--sd-container-name apache \
--target-group-arn ${AWS_ALB_ARN_APACHE} \
--container-name apache \
--container-port 80 