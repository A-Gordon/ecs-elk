# ELK on ECS using Terraform and ECS-CLI
Run an ELK stack using Terraform for the infrastructure related components and ECS-CLI to deploy the ECS services
The containers are currently deployed onto EC2 instances rather than Fargate.


> :information_source: The Docker images backing this stack include [Stack Features][stack-features] (formerly X-Pack)
with [paid features][paid-features] enabled by default (see [How to disable paid
features](#how-to-disable-paid-features) to disable them). The [trial license][trial-license] is valid for 30 days.

Based on the official Docker images from Elastic:

* [Elasticsearch](https://github.com/elastic/elasticsearch/tree/master/distribution/docker)
* [Logstash](https://github.com/elastic/logstash/tree/master/docker)
* [Kibana](https://github.com/elastic/kibana/tree/master/src/dev/build/tasks/os_packages/docker_generator)


## Contents

1. [Requirements](#requirements)
   * [Host setup](#host-setup)
2. [Usage](#usage)
   * [Bringing up the stack](#bringing-up-the-stack)


## Requirements

### Host setup

* [Terraform](https://www.terraform.io/) version **0.12.0** or newer
* [ecs-cli](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_CLI_installation.html)


By default, the stack exposes the following ports:
* 5000: Logstash TCP input
* 9200: Elasticsearch HTTP
* 9300: Elasticsearch TCP transport
* 5601: Kibana

## Usage
All containers are direct from elastic with minor config changes.

To deploy the applications as services is ecs and enable service discovery each service is deployed using the awsvpc network type. This grants each task an IP within the VPC and requires network configuration which is output from Terraform. These must be copied to the relevant variables in docker/deploy.sh and then it must be run before deploying the services with ecs-cli. 

This process should be made cleaner.

The Elasticsearch ec2 plugin does not work with ecs when using the awsvpc network mode. 

Each application in the ELK stack has been configured to be accessible via an ALB by accessing the ALB using the public DNS name and the application port. This will forward traffic the the repective service. 

### Bringing up the stack

#### Terraform
Terraform is used to provision the infrastructure
You will need access to an AWS account with API credentials. 
terraform/tfvars/terraform.tfvars is the base file for all variables required to provion the infrastucture. 


```console
$ terraform init
```

```console
$ terraform plan -var-file=tfvars/terraform.tfvars -state=tfstate/terraform.tfstate
```

```console
$ terraform apply -var-file=tfvars/terraform.tfvars -state=tfstate/terraform.tfstate
```

Once terraform has run it will output a few important details that are required to deploy the services using ecs-cli


#### ECS-CLI
This is used to provision the services from docker-compose and ecs-params files.
The ECS params files contain task specific definitions so each task/service has it's own file. To simplify the deployment process environment variables have been used to reduce the number of things that need to be configured. 

The current method of deployment is to copy the details output from Terraform into deploy.sh and run the script. 
This will set environment variables for all the configureable options within the ecs-params.yml files. 
The rest of the process is quite manual and requires you to run commands.sh in each of the directories for the ELK stack to spin up an ECS service with one task. 

Elasticsearch is different to this. It will spin up two services, one with a running task to initialise the cluster and another generic master service with 0 tasks running. This can be used to scale up the masters. 

Elasticsearch uses bridge networking as the EC2 plugin does not currently work with ECS tagging to discover other members. 



#### Logging
Apache can be ran locally or remotely on ECS with a filebeat sidecar container. Apache has been purposefully configured to log to file and filebeat has been configured to forward this to elasticsearch. 

To run remotely on EC2 run the commands within the docker/apache directory and access the ALB on the public DNS name on port 80. This will generate logs that will appear in Kibana.

To run locally you must change the environment variables in docker-compose within docker/apache to the public address of the ALB. 

### Known issues
Services may be slow to appear within the ALB due to the length of the health checks.

