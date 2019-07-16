#---compute/main.tf

data "aws_ami" "server_ami" {
    most_recent = true
    owners = ["amazon"]

    filter {
        name = "owner-alias"
        values = ["amazon"]
    }

    filter {
        name = "name"
        values = ["amzn-ami-hvm*-x86_64-gp2"]
    }
}

resource "aws_key_pair" "endava_auth" {
    key_name = "${var.key_name}"
    public_key = "${file(var.public_key_path)}"
}

# -----AUTO-SCALING GROUP-------------

resource "aws_launch_configuration" "webapp_on_demand" {
    instance_type = "${var.instance_type}"
    image_id = "${var.ecs_image_id}"
    iam_instance_profile = "${var.ecs_instance_profile}"
    user_data = "${data.template_file.autoscaling_user_data.rendered}"
    key_name = "${aws_key_pair.endava_auth.id}"
    security_groups = ["${var.endava_public_sg}"]
    associate_public_ip_address = true

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "webapp_on_demand" {
    name = "endava_webapp_on_demand"
    max_size = 50
    min_size = 0
    desired_capacity = "${var.desired_capacity_on_demand}"
    health_check_grace_period = 300
    health_check_type = "EC2"
    force_delete = true
    launch_configuration = "${aws_launch_configuration.webapp_on_demand.name}"
    vpc_zone_identifier = ["${var.endava_public_subnets}"]

    tag {
        key = "Name"
        value = "endava"
        propagate_at_launch = true
    }

    lifecycle {
        create_before_destroy = true
    }
}

data "template_file" "autoscaling_user_data" {
    template= "${file("${path.module}/autoscaling_user_data.tpl")}"
    vars {
        ecs_cluster = "${aws_ecs_cluster.cluster.name}"
    }
}

# -----ALB------------------

resource "aws_alb" "main" {
    lifecycle { create_before_destroy = true }
    name = "endava-alb"
    subnets = ["${var.endava_public_subnets}"]
    security_groups = ["${var.endava_public_sg}"]
    idle_timeout = 400
    tags {
        Name = "endava_alb"
    }
}

resource "aws_alb_target_group" "webapp_tg" {
    name                 = "webapp-tg"
    port                 = "80"
    protocol             = "HTTP"
    vpc_id               = "${var.vpc_id}"

    deregistration_delay = 180

    health_check {
        interval            = "60"
        path                = "/"
        port                = "80"
        healthy_threshold   = "3"
        unhealthy_threshold = "3"
        timeout             = "5"
        protocol            = "HTTP"
    }

    tags {
        Name = "webapp_tg"
    }

    depends_on = ["aws_alb.main"]
}

resource "aws_alb_listener" "frontend_http" {
    load_balancer_arn = "${aws_alb.main.arn}"
    port              = "80"
    protocol          = "HTTP"

    default_action {
        target_group_arn = "${aws_alb_target_group.webapp_tg.id}"
        type             = "forward"
    }

    depends_on = ["aws_alb.main"]
}

# --------ECS--------------

#--- Cluster definition, which is used in autoscaling.tf 

resource "aws_ecs_cluster" "cluster" {
    name = "endava_cluster"
}

#--- ECS service definitions

resource "aws_ecs_service" "webapp_service" {
    name = "endava_webapp_service"
    cluster = "${aws_ecs_cluster.cluster.id}"
    task_definition = "${aws_ecs_task_definition.webapp_definition.arn}"
    desired_count = "${var.instance_count}"
    deployment_minimum_healthy_percent = "${var.minimum_healthy_percent_webapp}"
    iam_role = "${var.ecs_service_role}"

    load_balancer {
        target_group_arn = "${aws_alb_target_group.webapp_tg.arn}"
        container_name = "webapp"
        container_port = 80
    }

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_ecs_task_definition" "webapp_definition" {
    family = "endava_webapp"
    container_definitions = "${data.template_file.task_webapp.rendered}"

    lifecycle {
        create_before_destroy = true
    }
}

data "template_file" "task_webapp" {
    template= "${file("${path.module}/ecs_task_webapp.tpl")}"

    vars {
        webapp_docker_image = "${var.webapp_docker_image_name}:${var.webapp_docker_image_tag}"
        endpoint = "${aws_db_instance.endava_mysql.endpoint}"
        aws_region = "${var.aws_region}"
    }
}

resource "aws_db_subnet_group" "rds" {
    name       = "rds"
    subnet_ids = ["${var.endava_private_subnets[0]}", "${var.endava_private_subnets[1]}"]

    tags = {
        Name = "My DB subnet group"
  }
}


#---Database instances

resource "aws_db_instance" "endava_mysql" {

    allocated_storage = "${var.db_storage_space}"
    storage_type = "gp2"
    engine = "${var.db_engine}"
    engine_version = "${var.db_engine_version}"
    instance_class = "${var.db_instance_type}"
    name = "${var.db_name}"
    username = "root"
    password = "${var.db_root_password}"
    allow_major_version_upgrade = false
    backup_retention_period = "${var.db_backup_period}"
    db_subnet_group_name = "${aws_db_subnet_group.rds.name}"
    vpc_security_group_ids = ["${var.endava_private_sg}"]
    skip_final_snapshot = true
}

