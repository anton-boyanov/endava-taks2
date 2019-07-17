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