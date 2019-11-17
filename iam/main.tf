#---iam/main.tf

resource "aws_iam_instance_profile" "ecs_instance_profile" {
    name = "e_ecs_instance_profile"
    role = "${aws_iam_role.ecs_instance_role.name}"
}
resource "aws_iam_role" "ecs_instance_role" {
    name = "apm_ecs_instance_role"
    assume_role_policy = "${data.template_file.ecs_instance_role.rendered}"
}
data "template_file" "ecs_instance_role" {
    template= "${file("iam/ecs_instance_role.tpl")}"
}
resource "aws_iam_role_policy" "ecs_instance_role_policy" {
    name = "apm_ecs_instance_role_policy"
    role = "${aws_iam_role.ecs_instance_role.id}"
    policy = "${data.template_file.ecs_instance_role_policy.rendered}"
}
data "template_file" "ecs_instance_role_policy" {
    template= "${file("iam/ecs_instance_role_policy.tpl")}"
}
resource "aws_iam_role" "ecs_service_role" {
    name = "apm_ecs_service_role"
    assume_role_policy = "${data.template_file.ecs_service_role.rendered}"
}
data "template_file" "ecs_service_role" {
    template= "${file("iam/ecs_service_role.tpl")}"
}
resource "aws_iam_role_policy" "ecs_service_role_policy" {
    name = "apm_ecs_service_role"
    role = "${aws_iam_role.ecs_service_role.id}"
    policy = "${data.template_file.ecs_service_role_policy.rendered}"
}
data "template_file" "ecs_service_role_policy" {
    template= "${file("iam/ecs_service_role_policy.tpl")}"
}
