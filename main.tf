// VPC - Creating the custom VPC in the cidr "172.16.0.0/16"
 
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
 
  tags = {
    Name = "${var.project}-${var.environment}"
  }
}
 
 
// Creating the Internet gateway for the public subnets and attach to VPC.
 
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
 
  tags = {
    Name = "${var.project}-${var.environment}"
  }
}
 
 
/* Creating Public and Private subnets based on the number of availability zones available in the region.*/
 
// Public Subnets:
 
resource "aws_subnet" "public" {
  count                   = local.subnets
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, count.index)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.project}-${var.environment}-public${count.index + 1}"
  }
}
 
 
// Private Subnets:
 
resource "aws_subnet" "private" {
  count             = local.subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, "${count.index + local.subnets}")
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.project}-${var.environment}-private${count.index + 1}"
  }
}
 
 
// Allocating an Elastic IP for the NAT Gateway.
 
resource "aws_eip" "nat" {
  vpc = true
  tags = {
    Name = "${var.project}-${var.environment}-nat_gw"
  }
}
 
 
// Attaching the Elastic IP for public access to the NAT Gateway.
 
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
 
  tags = {
    Name = "${var.project}-${var.environment}"
  }
 
 # To ensure proper ordering, it is recommended to add an explicit dependency
 # on the Internet Gateway for the VPC.
 
  depends_on = [aws_internet_gateway.igw]
}
 
 
// Associating Public route table with public subnets.
 
resource "aws_route_table_association" "public" {
  count          = local.subnets
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
 
 
// Associating the Private route table with private subnets.
 
resource "aws_route_table_association" "private" {
  count          = local.subnets
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
 
 
// Creating a Public route table for the Internet gateway.
 
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
 
  tags = {
    Name = "${var.project}-${var.environment}-public"
  }
}
 
 
// Creating a private route table to make the route for public access via the NAT gateway.
 
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
 
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
 
  tags = {
    Name = "${var.project}-${var.environment}-private"
  }
}
 
 
/* Creating Security groups for the bastion, frontend, and backend instances. */
 
// SG for Bastion:
 
resource "aws_security_group" "bastion-traffic" {
  name_prefix = "${var.project}-${var.environment}-bastion_"
  description = "Allow 22 inbound traffic Only"
  vpc_id      = aws_vpc.vpc.id
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
 
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
 
  lifecycle {
    create_before_destroy = true
  }
 
  tags = {
    "Name" = "${var.project}-${var.environment}-bastion"
 
  }
}
 
 
// SG for Frontend:
 
resource "aws_security_group" "frontend-traffic" {
  name_prefix = "${var.project}-${var.environment}-frontend_"
  description = "Allow 80 & 443 traffic from public, 22 from bastion"
  vpc_id      = aws_vpc.vpc.id
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
 
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
 
  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
 
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    security_groups  = [aws_security_group.bastion-traffic.id]
    ipv6_cidr_blocks = ["::/0"]
  }
 
 # Adding Life Cycle Policy.
 
  lifecycle {
    create_before_destroy = true
  }
 
  tags = {
    "Name" = "${var.project}-${var.environment}-frontend"
 
  }
}
 
 
// SG for Backend:
 
resource "aws_security_group" "backend-traffic" {
  name_prefix = "${var.project}-${var.environment}-backend_"
  description = "Allow 3306 from frontend & 22 from bastion"
  vpc_id      = aws_vpc.vpc.id
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
 
  ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = [aws_security_group.frontend-traffic.id]
    ipv6_cidr_blocks = ["::/0"]
  }
 
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    security_groups  = [aws_security_group.bastion-traffic.id]
    ipv6_cidr_blocks = ["::/0"]
  }
 
  lifecycle {
    create_before_destroy = true
  }
 
  tags = {
    "Name" = "${var.project}-${var.environment}-backend"

  }
}
 
 
// Registering the public key of an existing SSH Key Pair with AWS to allow logging-in to EC2 instances.
 
resource "aws_key_pair" "ssh_key" {
 
  key_name   = "${var.project}-${var.environment}"
  public_key = file("mykey.pub")
  tags = {
 
    "Name" = "${var.project}-${var.environment}"
  }
}
 
 
/* Creating instances for Bastion, Frontend, and Backend.*/
 
// Bastion Instance:
 
resource "aws_instance" "bastion" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids      = [aws_security_group.bastion-traffic.id]
  subnet_id                   = aws_subnet.public.1.id
  user_data                   = file("userdata-bastion.sh")
  user_data_replace_on_change = true
  tags = {
 
    "Name" = "${var.project}-${var.environment}-bastion"
  } 
}
 
 
// Frontend Instance:
 
resource "aws_instance" "frontend" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids      = [aws_security_group.frontend-traffic.id]
  subnet_id                   = aws_subnet.public.0.id
  user_data                   = file("userdata-frontend.sh")
  user_data_replace_on_change = true
  tags = {
 
    "Name" = "${var.project}-${var.environment}-frontend"
  }
 
 # Defining the dependancy with the Backend Server.
 
  depends_on = [aws_instance.backend]
}
 
 
// Backend Instance:
 
resource "aws_instance" "backend" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids      = [aws_security_group.backend-traffic.id]
  subnet_id                   = aws_subnet.private.0.id
  user_data                   = file("userdata-backend.sh")
  user_data_replace_on_change = true
  tags = {
 
    "Name" = "${var.project}-${var.environment}-backend"
  }
 
 # Defining the dependancy with the NAT Gateway.
 
  depends_on = [aws_nat_gateway.nat]
}
 
 
// Adding a Private Hosted Zone:
 
resource "aws_route53_zone" "private" {
  name = var.private_zone
 
  vpc {
    vpc_id = aws_vpc.vpc.id
  }
}
 
 
// Creating a subdomain in the Private hosted zone to use as the DB_Host for the website.
 
resource "aws_route53_zone" "db" {
  name = "db.${aws_route53_zone.private.name}"
 
}
 
 
// Adding an A record for the subdomain in the private hosted zone.
 
resource "aws_route53_record" "db" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "db.${aws_route53_zone.private.name}"
  type    = "A"
  ttl     = 300
  records = ["${aws_instance.backend.private_ip}"]
}
 
 
// Adding a subdomain in an already existing Public hosted zone for the WordPress website.
 
resource "aws_route53_record" "wordpress" {
  zone_id = data.aws_route53_zone.mydomain.zone_id
  name    = "wordpress.${data.aws_route53_zone.mydomain.name}"
  type    = "A"
  ttl     = 300
  records = [aws_instance.frontend.public_ip]
}
