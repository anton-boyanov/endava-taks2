#----networking/variables.tf

variable "vpc_cidr" {
    default = "10.2.0.0/16"
}

variable "public_cidrs" {
    type = "list"
    default = ["10.2.1.0/24", "10.2.2.0/24"]
}

variable "private_cidrs" {
    type = "list"
    default = ["10.2.3.0/24", "10.2.4.0/24"]
}

variable "accessip" {
    default = "0.0.0.0/0"
}
