
ecs-cli compose --region eu-west-1 \
--cluster andy-test \
--project-name elasticsearch \
--ecs-params ./ecs-params.yml \
--file docker-compose.yml \
service create \
--enable-service-discovery \
--vpc ${AWS_VPC_ID} \
--private-dns-namespace local \
--sd-container-name elasticsearch \
--sd-container-port 9200 \
--target-group-arn ${AWS_ALB_ARN_ES} \
--container-name elasticsearch \
--container-port 9200 \
--tags Cluster=andy-test \
--health-check-grace-period 180

ecs-cli compose --region eu-west-1 \
--cluster andy-test \
--project-name elasticsearch-init \
--ecs-params ./ecs-params.yml \
--file docker-compose-init.yml \
service up \
--enable-service-discovery \
--vpc ${AWS_VPC_ID} \
--private-dns-namespace local \
--sd-container-name elasticsearch \
--sd-container-port 9200 \
--target-group-arn ${AWS_ALB_ARN_ES} \
--container-name elasticsearch \
--container-port 9200 \
--tags Cluster=andy-test \
--health-check-grace-period 180

# ecs-cli compose --region eu-west-1 \
# --cluster andy-test \
# --project-name elasticsearch \
# --ecs-params ./ecs-params.yml \
# service down