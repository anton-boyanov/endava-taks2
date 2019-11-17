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

    vars = {
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

