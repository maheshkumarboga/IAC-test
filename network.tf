resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  instance_tenancy = "default"

  tags = {
    Name = format("%s-vpc", var.prefix)
  }
}
resource "aws_subnet" "public_subnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet1_cidr
  availability_zone = "ap-south-1a"

  tags = {
    Name = format("%s-subnet1", var.prefix)
  }
}
resource "aws_subnet" "private_subnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet2_cidr
  availability_zone = "ap-south-1a"

  tags = {
    Name = format("%s-subnet2", var.prefix)
  }
}
resource "aws_subnet" "secure_subnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet3_cidr
  availability_zone = "ap-south-1a"

  tags = {
    Name = format("%s-subnet3", var.prefix)
  }
}
resource "aws_subnet" "public_subnet2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet4_cidr
  availability_zone = "ap-south-1b"

  tags = {
    Name = format("%s-subnet4", var.prefix)
  }
}
resource "aws_subnet" "private_subnet2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet5_cidr
  availability_zone = "ap-south-1b"

  tags = {
    Name = format("%s-subnet5", var.prefix)
  }
}
resource "aws_subnet" "secure_subnet2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet6_cidr
  availability_zone = "ap-south-1b"

  tags = {
    Name = format("%s-subnet6", var.prefix)
  }
}
resource "aws_internet_gateway" "Mahesh_gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Mahesh_IG"
  }
}
resource "aws_eip" "Mahesh_lb" {
#   instance = aws_instance.web.id
  domain   = "vpc"
    tags = {
    Name = "Mahesh_EIP"
  }
}
resource "aws_nat_gateway" "Mahesh_NAT" {
  allocation_id = aws_eip.Mahesh_lb.id
  subnet_id     = aws_subnet.public_subnet1.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.Mahesh_gw]
}
resource "aws_route_table" "Mahesh_Public_RT" {
  vpc_id = aws_vpc.main.id

#   route = []
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Mahesh_gw.id
  }

  tags = {
    Name = "Public_RT"
  }
}
resource "aws_route_table" "Mahesh_Private_RT" {
  vpc_id = aws_vpc.main.id

#   route = []
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.Mahesh_NAT.id
  }

  tags = {
    Name = "Private_RT"
  }
}
resource "aws_route_table_association" "RTA_Public1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.Mahesh_Public_RT.id
}
resource "aws_route_table_association" "RTA_Public2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.Mahesh_Public_RT.id
}
resource "aws_route_table_association" "RTA_Private1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.Mahesh_Private_RT.id
}
resource "aws_route_table_association" "RTA_Private2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.Mahesh_Private_RT.id
}