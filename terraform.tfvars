aws_region = "eu-west-1"
vpc_cidr = "10.0.0.0/16"
public_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
private_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
accessip = "0.0.0.0/0"

key_name = "endavakey"
public_key_path = "$HOME/.ssh/id_rsa.pub"
instance_type = "t2.micro"
desired_capacity_on_demand = 2
instance_count = 2
minimum_healthy_percent_webapp = 50
webapp_docker_image_name = "phpmyadmin/phpmyadmin"
webapp_docker_image_tag = "latest"
ecs_image_id = "ami-0693ed7f"

db_storage_space = 20
db_engine = "mysql"
db_engine_version = "5.7"
db_instance_type = "db.t2.micro"
db_name = "endava"
#db_root_password = ""
db_backup_period = 5
