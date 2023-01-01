//
//

// Fetching the existing Public Hosted Zone.

data "aws_route53_zone" "mydomain" {
  name = var.public_zone
}


// Fetching the 'available' Avaialability Zones in the region.

data "aws_availability_zones" "available" {
  state = "available"
}
