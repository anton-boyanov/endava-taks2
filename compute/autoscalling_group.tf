# -----AUTO-SCALING GROUP-------------

resource "aws_launch_configuration" "webapp_on_demand" {
    instance_type = "${var.instance_type}"
    image_id = "${var.ecs_image_id}"
    iam_instance_profile = "${var.ecs_instance_profile}"
    user_data = "${data.template_file.autoscaling_user_data.rendered}"
    key_name = "${aws_key_pair.apm_auth.id}"
    security_groups = ["${var.apm_public_sg}"]
    associate_public_ip_address = true

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "webapp_on_demand" {
    name = "apm_webapp_on_demand"
    max_size = 50
    min_size = 0
    desired_capacity = "${var.desired_capacity_on_demand}"
    health_check_grace_period = 300
    health_check_type = "EC2"
    force_delete = true
    launch_configuration = "${aws_launch_configuration.webapp_on_demand.name}"
    vpc_zone_identifier = ["${var.apm_public_subnets}"]

    tag {
        key = "Name"
        value = "apm"
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
