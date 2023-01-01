# VPC-Terraform
#
## Creating a custom VPC using Terraform:
#
---------------------------------------------------------------
### _Resources we will be using in this setup:_
- Public subnets - 2
- Private subnet - 1
- Public route table - 1
- Private route table - 1
- NAT Gateway - 1
- Internet Gateway - 1
- Elastic IP - 1
- Bastion instance - 1
- Frontend instance for the webserver - 1
- Backend instance for the DB - 1
- Key Pair - 1
- Security Groups - 3
- VPC -1
- Public Hosted Zone - 1
- Private Hosted Zone - 1

---------------------------------------------------------------
#
## Table of Contents

- [Prequisites]()
- [Creating a working directory]()
- [Creating SSH Key Pair]()
- [Initialize the Terraform working directory]()
- [Terraform Command Lines Used]()
   - [Plan, Deploy and Destroy Infrastructure]()
---------------------------------------------------------------

## Prerequisites.

- Terraform must be installed and configured on your local machine. You can refer to [Terraform Official Website.](https://developer.hashicorp.com/terraform/downloads)
- An SSH Key Pair must be created under the infra directory (In this example, the SSH Key name should be "mykey").
----------------------------------------------------------
## Creating a working directory:

    # mkdir myprojectdir/
    # cd myprojectdir/

----------------------------------------------------------------

## Creating SSH Key Pair:
#
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
#
--------------------------------------------------------------------

## Initialize the Terraform working directory:
#

    # terraform init 
    // initialize directory, pull down providers
-----------------------------------------------------------------------
#
## Terraform Command Lines Used:
#
#### Plan, Deploy and Destroy Infrastructure:
#
    # terraform plan 
    // Output the deployment plan.
#
    # terraform apply
    // Apply the changes to the infrastructure.
#
    # terraform apply --auto-approve 
    // Apply changes without being prompted to enter “yes”.
#
    # terraform destroy
    // Destroy/cleanup the deployment
#
    # terraform destroy --auto-approve 
    // Destroy/cleanup deployment without being prompted for “yes”.
