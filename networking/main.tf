#----networking/main.tf

data "aws_availability_zones" "available" {}

#---VPC---

resource "aws_vpc" "apm_vpc" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags {
        Name = "apm_vpc"
    }
}

#---Internet Gateway---

resource "aws_internet_gateway" "apm_igw" {
    vpc_id = "${aws_vpc.apm_vpc.id}"

    tags {
        Name = "apm_igw"
    }
}

#---Rout Tables---

resource "aws_route_table" "apm_public_rt" {
    vpc_id = "${aws_vpc.apm_vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.apm_igw.id}"
    }

    tags {
        Name = "apm_public_rt"
    }
}

resource "aws_route_table" "apm_private_rt" {
    vpc_id = "${aws_vpc.apm_vpc.id}"
    tags {
        Name = "apm_private_rt"
    }
}

#---Subnets---

resource "aws_subnet" "apm_public_subnet" {
    count = 2
    vpc_id = "${aws_vpc.apm_vpc.id}"
    cidr_block = "${var.public_cidrs[count.index]}"
    map_public_ip_on_launch = true
    availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  
    tags {
        Name = "apm_public${count.index + 1}"
    }
}

resource "aws_subnet" "apm_private_subnet" {
    count = 2
    vpc_id = "${aws_vpc.apm_vpc.id}"
    cidr_block = "${var.private_cidrs[count.index]}"
    map_public_ip_on_launch = false
    availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

    tags {
        Name = "apm_private${count.index + 3}"
    }
}

#---Route Table ACCOSSIATIONS---

resource "aws_route_table_association" "apm_public_assoc" {
    count = "${aws_subnet.apm_public_subnet.count}"
    subnet_id = "${aws_subnet.apm_public_subnet.*.id[count.index]}"
    route_table_id = "${aws_route_table.apm_public_rt.id}"
}

resource "aws_route_table_association" "apm_private_rt_assoc" {
    count = "${aws_subnet.apm_private_subnet.count}"
    subnet_id = "${aws_subnet.apm_private_subnet.*.id[count.index]}"
    route_table_id = "${aws_route_table.apm_private_rt.id}"
}


#---PUBLIC SG

resource "aws_security_group" "apm_public_sg" {
    name = "apm_public_sg"
    description = "Used for access to public instances"
    vpc_id = "${aws_vpc.apm_vpc.id}"
  
    tags {
        Name = "apm_public_sg"
    }

  #SSH

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.accessip}"]
    }

  #HTTP

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["${var.accessip}"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

#---PRIVATE SG

resource "aws_security_group" "apm_private_sg" {
    name = "apm_private_sg"
    description = "Used to put MySql instances"
    vpc_id = "${aws_vpc.apm_vpc.id}"
  
    tags {
        Name = "apm_private_sg"
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

#---ALB SG

resource "aws_security_group" "apm_alb_sg" {
    name = "apm_alb_sg"
    description = "Used for ALB"
    vpc_id = "${aws_vpc.apm_vpc.id}"
  
    tags {
        Name = "apm_alb_sg"
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group_rule" "allow_3306_from_app" {
    type = "ingress"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"

    security_group_id = "${aws_security_group.apm_private_sg.id}"
    source_security_group_id = "${aws_security_group.apm_public_sg.id}"
}

resource "aws_security_group_rule" "allow_ssh_from_app" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"

    security_group_id = "${aws_security_group.apm_private_sg.id}"
    source_security_group_id = "${aws_security_group.apm_public_sg.id}"
}

resource "aws_vpc_dhcp_options" "dns_resolver" {
    domain_name_servers = ["AmazonProvidedDNS"]

    tags {
        Name = "apm-app"
    }
}

resource "aws_vpc_dhcp_options_association" "a" {
    vpc_id = "${aws_vpc.apm_vpc.id}"
    dhcp_options_id = "${aws_vpc_dhcp_options.dns_resolver.id}"
}
