#---compute/variables.tf

variable "key_name" {
    default = "endavakey"
}

variable "aws_region" {
    default = "eu-west-1"
}

variable "ecs_image_id" {
    default = "ami-0693ed7f"
}

variable "public_key_path" {
    default = "$HOME/.ssh/id_rsa.pub"
}
variable "instance_type" {
    default = "t2.micro"
}
variable "ecs_instance_profile" {}
variable "endava_public_sg" {}
variable "desired_capacity_on_demand" {
    default = 2
}
variable "endava_public_subnets" {
    type = "list"
}
variable "instance_count" {
    default = 2
}
variable "minimum_healthy_percent_webapp" {
    default = 50
}
variable "ecs_service_role" {
    default = "endava_ecs_service_role"
}
variable "endava_private_sg" {}
variable "endava_alb_sg" {}
variable "endava_private_subnets" {
    type = "list"
}
variable "webapp_docker_image_name" {
    default = "phpmyadmin/phpmyadmin"
}
variable "webapp_docker_image_tag" {
    default = "latest"
}
variable "vpc_id" {}

variable "db_storage_space" {}
variable "db_engine" {}
variable "db_engine_version" {}
variable "db_instance_type" {}
variable "db_name" {}
variable "db_root_password" {}
variable "db_backup_period" {}
