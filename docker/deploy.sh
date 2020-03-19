#!/bin/bash

export AWS_VPC_ID="vpc-0edb83357d6053873"
export AWS_VPC_SUBNET_1="subnet-06dd1b3cec855ffad"
export AWS_VPC_SUBNET_2="subnet-02cf3fae5feca431e"
export AWS_VPC_SUBNET_3="subnet-03ea0069692d86acb"
export AWS_VPC_SG="sg-0e05806c537ba871a"

export AWS_IAM_ROLE_ARN_ES="arn:aws:iam::462727225103:role/andy-test-elastic"

export AWS_ALB_ARN_APACHE="arn:aws:elasticloadbalancing:eu-west-1:462727225103:targetgroup/andy-test-apache/a7c0648bf1f17c56"
export AWS_ALB_ARN_ES="arn:aws:elasticloadbalancing:eu-west-1:462727225103:targetgroup/andy-test-elasticsearch/8304f746d8439e51"
export AWS_ALB_ARN_KIBANA="arn:aws:elasticloadbalancing:eu-west-1:462727225103:targetgroup/andy-test-kibana/43d90ae529d0c72f"
export AWS_ALB_ARN_LOGSTASH="arn:aws:elasticloadbalancing:eu-west-1:462727225103:targetgroup/andy-test-logstash/888fdff01bd31f64"

export R53_ZONE_ID="Z031953722KHVK18N7WLJ"
