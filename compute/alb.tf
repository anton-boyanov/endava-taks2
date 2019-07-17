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
