#!/bin/bash
set -x
set -e

# Update instance
yum update -y

# Join ECS cluster
echo 'ECS_CLUSTER=${ecs_cluster}' > /etc/ecs/ecs.config
start ecs
