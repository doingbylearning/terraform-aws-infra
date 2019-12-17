provider "aws" {
  version = "~> 2.0"
  region  = var.region
}

terraform {
  backend "s3" {}
}

resource "aws_vpc" "main" {
  cidr_block = var.cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = var.name
  }
}

resource "aws_subnet" "public" {
  count      = length(var.public_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.public_subnet_cidr, count.index)
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = format("public-subnet-%s-%d", var.name, count.index)
  }
}

resource "aws_subnet" "private" {
  count      = length(var.private_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.private_subnet_cidr, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = format("private-subnet-%s-%d", var.name, count.index)
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.name
  }
}

resource "aws_eip" "private_main" {
  count = length(var.private_subnet_cidr)
  vpc = true
}

resource "aws_nat_gateway" "main" {
  count = length(var.private_subnet_cidr)
  allocation_id = element(aws_eip.private_main.*.id, count.index)
  subnet_id = element(aws_subnet.public.*.id, count.index)

  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table" "public" {
  count = length(var.public_subnet_cidr)
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "public" {
  count = length(var.public_subnet_cidr)
  route_table_id = element(aws_route_table.public.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}

resource "aws_route_table" "private" {
  count = length(var.private_subnet_cidr)
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "private" {
  count = length(var.private_subnet_cidr)
  route_table_id = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = element(aws_nat_gateway.main.*.id, count.index)
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = element(aws_route_table.public.*.id, count.index)
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}
