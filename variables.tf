variable "aws_region" {}
variable "vpc_cidr" {}
variable "public_cidrs" {
    type = "list"
}
variable "private_cidrs" {
    type = "list"
}
variable "accessip" {}
variable "ecs_image_id" {}
variable "key_name" {}
variable "public_key_path" {}
variable "instance_count" {}
variable "instance_type" {}
variable "minimum_healthy_percent_webapp" {}
variable "webapp_docker_image_name" {}
variable "webapp_docker_image_tag" {}
variable "desired_capacity_on_demand" {}

variable "db_storage_space" {}
variable "db_engine" {}
variable "db_engine_version" {}
variable "db_instance_type" {}
variable "db_name" {}
variable "db_root_password" {}
variable "db_backup_period" {}