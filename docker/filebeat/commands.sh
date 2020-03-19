ecs-cli compose --project-name apache --region eu-west-1 --cluster andy-test --verbose create

ecs-cli compose --region eu-west-1 \
--cluster andy-test \
--ecs-params ./ecs-params.yml \
service create \
--enable-service-discovery \
--vpc vpc-0edb83357d6053873 \
--private-dns-namespace aws \
--sd-container-name apache 