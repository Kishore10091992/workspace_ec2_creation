terraform {
 required_providers {
  aws = {
   source = "hashicorp/aws"
   version = "~>5.0"
  }
 }
}

provider "aws" {
 region = var.aws_region
}

locals {
 project = terraform.workspace
 
 vpc_cidr_map = {
  dev = var.dev_vpc
  stage = var.stg_vpc
  prod = var.prod_vpc
 }
 
 subnet_cidr_map = {
  dev = var.dev_sub
  stage = var.stg_sub
  prod = var.prod_sub
 }
}

resource "aws_vpc" "ws_vpc" {
 cidr_block = lookup(local.vpc_cidr_map, terraform.workspace, "172.0.0.0/16")

 tags = {
  Name = "${local.project}-vpc-${terraform.workspace}"
 }
}

resource "aws_subnet" "ws_subnet" {
 vpc_id = aws_vpc.ws_vpc.id
 cidr_block = lookup(local.subnet_cidr_map, terraform.workspace, "172.0.0.0/16")

 tags = {
  Name = "${local.project}-subnet-${terraform.workspace}"
 }
}

resource "aws_internet_gateway" "ws_igw" {
 vpc_id = aws_vpc.ws_vpc.id

 tags = {
  Name = "${local.project}-igw-${terraform.workspace}"
 }
}

resource "aws_route_table" "ws_rt" {
 vpc_id = aws_vpc.ws_vpc.id

 route {
  cidr_block = var.default_ip
  gateway_id = aws_internet_gateway.ws_igw.id
 }

 tags = {
  Name = "${local.project}-rt-${terraform.workspace}"
 }
}

resource "aws_route_table_association" "ws_rt_ass" {
 subnet_id = aws_subnet.ws_subnet.id
 route_table_id = aws_route_table.ws_rt.id
}

resource "aws_security_group" "ws_sg" {
 vpc_id = aws_vpc.ws_vpc.id

 ingress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [var.default_ip]
 }

 egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [var.default_ip]
 }

 tags = {
  Name = "${local.project}-sg-${terraform.workspace}"
 }
}

resource "aws_network_interface" "ws_nic" {
 subnet_id = aws_subnet.ws_subnet.id
 security_groups = [aws_security_group.ws_sg.id]
}

resource "aws_eip" "ws_eip" {
 domain = "vpc"
 network_interface = aws_network_interface.ws_nic.id

 tags = {
  Name = "${local.project}-eip-${terraform.workspace}"
 }
}

data "aws_ami" "ws_ami_lnx" {
 most_recent = true
 owners = ["amazon"]

 filter {
  name = "name"
  values = ["amzn2-ami-hvm-*"]
 }
}

data "aws_key_pair" "keypair" {
 key_name = "Terraform_ec2"
}

resource "aws_instance" "ws_ec2" {
 ami = data.aws_ami.ws_ami_lnx.id
 instance_type = var.instance_type
 key_name = data.aws_key_pair.keypair.key_name

  network_interface {
    network_interface_id = aws_network_interface.ws_nic.id
    device_index         = 0
  }

 tags = {
  Name = "${local.project}-ec2-${terraform.workspace}"
 }
}