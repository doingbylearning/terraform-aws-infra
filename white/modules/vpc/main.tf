# Configure the AWS Provider
provider "aws" {
  version = "~> 2.0"
  region  = var.region
}

# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = var.cidr
  enable_dns_hostnames = true
  tags = {
    Name = var.name
  }
}