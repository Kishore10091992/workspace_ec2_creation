variable "default_ip" {
 description = "default ip address"
 type = string
 default = "0.0.0.0/0"
}

variable "instance_type" {
 description = "ec2 instance type"
 type = string
 default = "t2.micro"
}

variable "aws_region" {
 description = "infra region"
 type = string
 default = "us-east-1"
}

variable "dev_vpc" {
 description = "dev env vpc"
 type = string
 default = "172.1.0.0/16"
}

variable "stg_vpc" {
 description = "stg env vpc"
 type = string
 default = "172.2.0.0/16"
}

variable "prod_vpc" {
 description = "prod env vpc"
 type = string
 default = "172.3.0.0/16"
}

variable "dev_sub" {
 description = "dev env sub"
 type = string
 default = "172.1.1.0/24"
}

variable "stg_sub" {
 description = "stg env sub"
 type = string
 default = "172.2.1.0/24"
}

variable "prod_sub" {
 description = "prod env sub"
 type = string
 default = "172.3.1.0/24"
}