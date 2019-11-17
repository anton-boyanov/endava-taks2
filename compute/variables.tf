#---compute/variables.tf

variable "key_name" {
    default = "apmkey"
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
variable "apm_public_sg" {}
variable "desired_capacity_on_demand" {
    default = 2
}
variable "apm_public_subnets" {
    type = "list"
}
variable "instance_count" {
    default = 2
}
variable "minimum_healthy_percent_webapp" {
    default = 50
}
variable "ecs_service_role" {
    default = "apm_ecs_service_role"
}
variable "apm_private_sg" {}
variable "apm_alb_sg" {}
variable "apm_private_subnets" {
    type = "list"
}
variable "httpd_docker_image_name" {
    default = "httpd"
}
variable "httpd_docker_image_tag" {
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
