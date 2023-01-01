//
//
// Name of the Project:

variable "project" {

  default     = "zomato"
  description = "Name of the project"

}


// Environment of the Project:

variable "environment" {

  default     = "production"
  description = "Environment of the project"

}


// Region of the Project:

variable "region" {

  default     = "ap-south-1"
  description = "Region of the project"

}


// Access Key for the IAM User.

variable "access_key" {

  default     = "XXXXXXXXXXXXXXXXXXXX"
  description = "My access key"

}

  
// Secret Key of the IAM User.
    
variable "secret_key" {

  default     = "XXXxXxxxXXXXXXxxXXxxxXXXXXxxxXXX"
  description = "My secret key"

}
  

// Defining 'locals' to reduce the duplication of code.
  
locals {
  
  # Getting the count of the usable Availability Zones in the region.
  
  subnets = length(data.aws_availability_zones.available.names)
  
  # Defining the tags that can be used commonly for different resources.
  
  common_tags = {
    "project"     = var.project
    "environment" = var.environment
  }
}

  
// CIDR of the VPC.
  
variable "vpc_cidr" {

  default     = "172.16.0.0/16"
  description = "CIDR block of the VPC"
}


// Defining the AMI used for the Instances in the project.
    
variable "instance_ami" {

  default     = "ami-0cca134ec43cf708f"
  description = "AMI ID of the instance"

}

  
// Defining the Type of the Instances in the project.
  
variable "instance_type" {

  default     = "t2.micro"
  description = "Instance Type"

}

  
// Defining the existing public domain name under the IAM user.
  
variable "public_zone" {

  default     = "myprojectdomain.com"
  description = "Public domain name"

}

  
// Defining the Private domain name.
    
variable "private_zone" {

  default     = "mydb-backend.local"
  description = "Private domain name"

}
