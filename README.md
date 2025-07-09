Terraform Configuration Overview

**This configuration enables you to deploy isolated, environment-specific AWS infrastructure by simply switching Terraform workspaces, making it scalable and maintainable for multiple environments.**

---

## 1. `variable.tf` – Input Variables

This file defines all the variables used to parameterize your infrastructure. These variables make the configuration flexible and reusable for different environments.

- **default_ip**: The default CIDR block for network access (default: `0.0.0.0/0`, which means open to all IPs).
- **instance_type**: The type of EC2 instance to launch (default: `t2.micro`).
- **aws_region**: The AWS region where resources will be created (default: `us-east-1`).
- **dev_vpc, stg_vpc, prod_vpc**: The CIDR blocks for the VPCs in development, staging, and production environments.
- **dev_sub, stg_sub, prod_sub**: The CIDR blocks for the subnets in each environment.

These variables allow you to easily switch between environments and customize network settings without changing the main configuration.

---

## 2. `main.tf` – Resource Definitions

This is the main file where AWS resources are defined and configured.

### Provider and Locals

- **Provider Block**: Configures the AWS provider using the region specified in `aws_region`.
- **Locals Block**: 
  - `project`: Uses the current Terraform workspace name (e.g., `dev`, `stage`, `prod`).
  - `vpc_cidr_map` and `subnet_cidr_map`: Maps each environment to its respective VPC and subnet CIDR blocks using the variables from `variable.tf`.

### Resource Creation

- **VPC (`aws_vpc.ws_vpc`)**: Creates a Virtual Private Cloud using the CIDR block for the current workspace/environment.
- **Subnet (`aws_subnet.ws_subnet`)**: Creates a subnet within the VPC, using the mapped CIDR block.
- **Internet Gateway (`aws_internet_gateway.ws_igw`)**: Attaches an internet gateway to the VPC for internet access.
- **Route Table (`aws_route_table.ws_rt`)**: 
  - Creates a route table for the VPC.
  - Adds a default route (`0.0.0.0/0`) to the internet gateway.
- **Route Table Association (`aws_route_table_association.ws_rt_ass`)**: Associates the route table with the subnet.
- **Security Group (`aws_security_group.ws_sg`)**: 
  - Allows all inbound and outbound traffic (using `default_ip`).
- **Network Interface (`aws_network_interface.ws_nic`)**: Creates a network interface in the subnet and attaches the security group.
- **Elastic IP (`aws_eip.ws_eip`)**: Allocates an Elastic IP and associates it with the network interface.
- **AMI Data Source (`data.aws_ami.ws_ami_lnx`)**: Fetches the latest Amazon Linux 2 AMI.
- **Key Pair Data Source (`data.aws_key_pair.keypair`)**: References an existing EC2 key pair named `Terraform_ec2`.
- **EC2 Instance (`aws_instance.ws_ec2`)**: 
  - Launches an EC2 instance using the selected AMI, instance type, and key pair.
  - Attaches the previously created network interface.

### Workspace-based Environment

By using `terraform.workspace` and the local maps, the configuration automatically selects the correct VPC and subnet CIDR blocks for the current environment (dev, stage, prod). This enables easy multi-environment deployments.

---

## 3. `output.tf` – Outputs

This file defines outputs to display after Terraform applies the configuration. These outputs provide important resource IDs for further use or reference:

- **vpc_id**: The ID of the created VPC.
- **subnet_id**: The ID of the created subnet.
- **internet_gateway_id**: The ID of the internet gateway.
- **route_table_id**: The ID of the route table.
- **security_group_id**: The ID of the security group.
- **ec2_instance_id**: The ID of the EC2 instance.

---

## Summary

- **`variable.tf`**: Defines all configurable parameters for your infrastructure.
- **`main.tf`**: Provisions AWS resources (VPC, subnet, gateway, security group, EC2, etc.) using those variables and the current workspace.
- **`output.tf`**: Exposes key resource IDs after deployment for easy reference.
