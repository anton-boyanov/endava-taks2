#---networking/outputs.tf

output "endava_public_subnets" {
    value = "${aws_subnet.endava_public_subnet.*.id}"
}

output "endava_private_subnets" {
    value = "${aws_subnet.endava_private_subnet.*.id}"
}

output "endava_private_sg" {
    value = "${aws_security_group.endava_private_sg.id}"
}

output "endava_public_sg" {
    value = "${aws_security_group.endava_public_sg.id}"
}

output "endava_alb_sg" {
    value = "${aws_security_group.endava_alb_sg.id}"
}

output "vpc_id" {
    value = "${aws_vpc.endava_vpc.id}"
}
