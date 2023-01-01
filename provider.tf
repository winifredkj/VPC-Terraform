// Defining AWS Provider to enable interaction with the AWS API.

provider "aws" {

  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key


  default_tags {

    tags = local.common_tags
  }
}
