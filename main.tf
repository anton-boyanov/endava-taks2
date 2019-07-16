provider "aws" {
    region = "${var.aws_region}"
}

# IAM
module "iam" {
    source = "./iam"
}


# Deploy networking resources
module "networking" {
    source = "./networking"
    vpc_cidr = "${var.vpc_cidr}"
    public_cidrs = "${var.public_cidrs}"
    accessip = "${var.accessip}"
    
}

# Deploy compute resources
module "compute" {
    source = "./compute"
    key_name = "${var.key_name}"
    public_key_path = "${var.public_key_path}"
    instance_count = "${var.instance_count}"
    instance_type = "${var.instance_type}"
    endava_public_sg = "${module.networking.endava_public_sg}"
    endava_private_sg = "${module.networking.endava_private_sg}"
    endava_alb_sg = "${module.networking.endava_alb_sg}"
    endava_public_subnets = "${module.networking.endava_public_subnets}"
    endava_private_subnets = "${module.networking.endava_private_subnets}"
    ecs_image_id = "${var.ecs_image_id}"
    minimum_healthy_percent_webapp = "${var.minimum_healthy_percent_webapp}"
    ecs_instance_profile = "${aws_iam_instance_profile.ecs_instance_profile.arn}"
    ecs_service_role = "${aws_iam_role.ecs_service_role.name}"
    webapp_docker_image_name = "${var.webapp_docker_image_name}"
    webapp_docker_image_tag = "${var.webapp_docker_image_tag}"
    desired_capacity_on_demand = "${var.desired_capacity_on_demand}"
    vpc_id = "${module.networking.vpc_id}"
    ecs_instance_profile = "${module.iam.ecs_instance_profile}"
    ecs_service_role = "${module.iam.ecs_service_role}"
    
    db_storage_space = "${var.db_storage_space}"
    db_engine = "${var.db_engine}"
    db_engine_version = "${var.db_engine_version}"
    db_instance_type = "${var.db_instance_type}"
    db_name = "${var.db_name}"
    db_root_password = "${var.db_root_password}"
    db_backup_period = "${var.db_backup_period}"
    
}
