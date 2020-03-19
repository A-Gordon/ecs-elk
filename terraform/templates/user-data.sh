#!/bin/bash

# ECS config
{
  echo "ECS_CLUSTER=${cluster_name}"
} >> /etc/ecs/ecs.config

echo 'vm.max_map_count = 262144' >> /etc/sysctl.conf
sysctl -p
mkdir -p /usr/share/elasticsearch/data/
chown -R 1000.1000 /usr/share/elasticsearch/data/

start ecs

echo "Done"