#!/bin/bash

ecs-cli compose --region eu-west-1 \
--cluster andy-test \
--project-name kibana \
--ecs-params ./ecs-params.yml \
service up \
--enable-service-discovery \
--vpc ${AWS_VPC_ID} \
--private-dns-namespace local \
--sd-container-name kibana \
--target-group-arn ${AWS_ALB_ARN_KIBANA} \
--container-name kibana \
--container-port 5601 \
--health-check-grace-period 180
