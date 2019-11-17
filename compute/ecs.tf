# --------ECS--------------

#--- Cluster definition, which is used in autoscaling.tf 

resource "aws_ecs_cluster" "apm-dev-cluster" {
    name = "apm-dev"
}

#--- ECS service definitions

resource "aws_ecs_task_definition" "httpd" {
    family = "services"
    container_definitions = "${data.template_file.task_def.rendered}"

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_ecs_service" "httpd_service" {
    name = "httpd_service"
    cluster = "${aws_ecs_cluster.apm-dev-cluster.id}"
    task_definition = "${aws_ecs_task_definition.httpd.arn}"
    desired_count = "${var.instance_count}"
    deployment_minimum_healthy_percent = "${var.minimum_healthy_percent_webapp}"
    iam_role = "${var.ecs_service_role}"

    load_balancer {
        target_group_arn = "${aws_alb_target_group.webapp_tg.arn}"
        container_name = "httpd"
        container_port = 80
    }

    lifecycle {
        create_before_destroy = true
    }
}

data "template_file" "httpd" {
    template= "${file("${path.module}/httpd.tpl")}"

    vars {
        httpd_docker_image = "${var.httpd_docker_image_name}:${var.httpd_docker_image_tag}"
        endpoint = "${aws_db_instance.apm_mysql.endpoint}"
        aws_region = "${var.aws_region}"
    }
}

resource "aws_db_subnet_group" "rds" {
    name       = "rds"
    subnet_ids = ["${var.apm_private_subnets[0]}", "${var.apm_private_subnets[1]}"]

    tags = {
        Name = "My DB subnet group"
  }
}

