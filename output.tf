
output "vpc_id" {
  value = aws_vpc.ws_vpc.id
  description = "The ID of the VPC"
}

output "subnet_id" {
  value = aws_subnet.ws_subnet.id
  description = "The ID of the Subnet"
}

output "internet_gateway_id" {
  value = aws_internet_gateway.ws_igw.id
  description = "The ID of the Internet Gateway"
}

output "route_table_id" {
  value = aws_route_table.ws_rt.id
  description = "The ID of the Route Table"
}

output "security_group_id" {
  value = aws_security_group.ws_sg.id
  description = "The ID of the Security Group"
}

output "ec2_instance_id" {
  value = aws_instance.ws_ec2.id
  description = "The ID of the EC2 Instance"
}
