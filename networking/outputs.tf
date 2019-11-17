#---networking/outputs.tf

output "apm_public_subnets" {
    value = "${aws_subnet.apm_public_subnet.*.id}"
}

output "apm_private_subnets" {
    value = "${aws_subnet.apm_private_subnet.*.id}"
}

output "apm_private_sg" {
    value = "${aws_security_group.apm_private_sg.id}"
}

output "apm_public_sg" {
    value = "${aws_security_group.apm_public_sg.id}"
}

output "apm_alb_sg" {
    value = "${aws_security_group.apm_alb_sg.id}"
}

output "vpc_id" {
    value = "${aws_vpc.apm_vpc.id}"
}
