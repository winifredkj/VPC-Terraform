# AWS VPC - Terraform

In this project, I am trying to create and set up a VPC and host a WordPress website using Terraform.

This setup simplifies the installation and configuration of the WordPress website using AWS EC2 instances. 

## Project Overview

In this project, a WordPress website installation will be done using an infrastructure of three AWS EC2 instances with the help of Terraform.

The WordPress website file contents will be stored in an EC2 instance called "Frontend" and the database will be stored in a separate EC2 instance called "Backend". There will be another EC2 instance called "Bastion" from only which we can access these 'Frontend' and 'Backend' servers via SSH.

Also, for the 'Backend' server, we are using a private subnet so that public access will be restricted. Only the 'Frontend' server can access the database service port on the "Backend" server to use it as the Database Host server for the website. The 'Frontend' server is capable of accepting HTTP & HTTPS connections from any network.

We have used the Terraform function "cidrsubnet()" to create the public and private subnets so that they can be created automatically. Also, one of the key features of the project is the number of subnets (private/public) created will be automatically fetched based on the number of available Availability Zones in the working region.

Let’s get to the code!

## Creating a custom VPC using Terraform:

### Core Features:

> * Private/Public subnets will be automatically created based on the number of Availability Zones in the region.
> * Subnetting has been automatically done using the Terraform "cidrsubnet" function.

---------------------------------------------------------------

### Resources we will be using in this setup:

- VPC
- Public subnets
- Private subnets
- Public route table
- Private route table
- NAT Gateway
- Internet Gateway
- Elastic IP
- Key Pair
- Bastion instance
- Frontend instance for the webserver
- Backend instance for the DB
- Security Groups
- Public Hosted Zone
- Private Hosted Zone

---------------------------------------------------------------

## Table of Contents

- [Prequisites](https://github.com/winifredkj/VPC-Terraform/blob/main/README.md#prerequisites)
- [Creating a working directory](https://github.com/winifredkj/VPC-Terraform/blob/main/README.md#creating-a-working-directory)
- [Creating SSH Key Pair](https://github.com/winifredkj/VPC-Terraform/blob/main/README.md#creating-ssh-key-pair)
- [Initialize the Terraform working directory](https://github.com/winifredkj/VPC-Terraform/blob/main/README.md#initialize-the-terraform-working-directory)
- [Terraform Command Lines Used](https://github.com/winifredkj/VPC-Terraform/blob/main/README.md#terraform-command-lines-used)
   - [Plan, Deploy and Destroy Infrastructure](https://github.com/winifredkj/VPC-Terraform/blob/main/README.md#plan-deploy-and-destroy-infrastructure)
---------------------------------------------------------------

## Prerequisites.

- Terraform (preferably Terraform v1.3.6) must be installed and configured on your local machine. You can refer to [Terraform Official Website.](https://developer.hashicorp.com/terraform/downloads)
- An SSH Key Pair must be created under the infra directory (In this example, the SSH Key name should be "mykey").
- IAM user with Programmatic access to AWS with AmazonEc2FullAccess and AmazonRoute53FullAccess
- A Public Hosted Zone with a valid domain in AWS.
----------------------------------------------------------

## Creating a working directory:

    # mkdir myprojectdir/
    # cd myprojectdir/

----------------------------------------------------------------

## Creating SSH Key Pair:

    $ ssh-keygen
    Generating public/private rsa key pair.
    Enter file in which to save the key (/home/ec2-user/.ssh/id_rsa): mykey
    Enter passphrase (empty for no passphrase):
    Enter same passphrase again:
    Your identification has been saved in mykey.
    Your public key has been saved in mykey.pub.
    The key fingerprint is:
    SHA256:9P3iB0fiTxGqmfMLIZpGSewLhGwR75AOuadAGcwDvcg ec2-user@ip-172-31-37-54.ap-south-1.compute.internal
    The key's randomart image is:
    +---[RSA 2048]----+
    |=oo.             |
    | *+= .        .  |
    |++B.o o .    . . |
    |oE.+ o o . .o o  |
    |o o o + S o=.o . |
    |.o   o + .=.o.o  |
    |.     =   .o.=.  |
    |     .     o..o  |
    |            oo   |
    +----[SHA256]-----+
    $

--------------------------------------------------------------------

## Initialize the Terraform working directory:


    # terraform init 
    // initialize directory, pull down providers
-----------------------------------------------------------------------

## Terraform Command Lines Used:

### Plan, Deploy and Destroy Infrastructure:
###
    # terraform validate
    // Outputs if the configuration is valid or not.
###    
    # terraform plan 
    // Outputs the deployment plan.
###
    # terraform apply
    // Apply the changes to the infrastructure.
###
    # terraform apply --auto-approve 
    // Apply changes without being prompted to enter “yes”.
###
    # terraform destroy
    // Destroy/cleanup the deployment
###
    # terraform destroy --auto-approve 
    // Destroy/cleanup deployment without being prompted for “yes”.
    

## Customize the Variables Used:

You can customize the variables used in the project by editing the '_default_' values if needed.

_The variables and their customizable default values:_

> * Name of the Project (Optional) - "project".
> * Envirnonment of the Project (Optional) - "environment"
> * Region Used (Optional) - "region"
> * Access Key of the IAM User - "access_key"
> * Secret Key of teh IAM User - "secret_key"
> * CIDR Subnet (Optional) - "vpc_cidr"
> * The AMI for the instances (Optional) - "instance_ami"
> * The type of the instances (Optional) - "instance_type"
> * Public Domain Name used for the WordPress Website - "public_zone"
> * Private Domain Name used as the Database Host (Optional) - "private_zone"

###
> Note: 
>
> If you are changing the default value of the variable "_private_zone_", then you must edit the file "_userdata-frontend.sh_" with same value for the Database Host.
