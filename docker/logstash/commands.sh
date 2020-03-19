#!/bin/bash

ecs-cli compose --region eu-west-1 \
--cluster andy-test \
--project-name logstash \
--ecs-params ./ecs-params.yml \
service up \
--enable-service-discovery \
--vpc ${AWS_VPC_ID} \
--private-dns-namespace local \
--sd-container-name logstash \
--target-group-arn ${AWS_ALB_ARN_LOGSTASH} \
--container-name logstash \
--container-port 5000 \
--health-check-grace-period 180