variable "cidr" {
  description = "AWS VPC CIDR"
  type = string
}

variable "region" {
  description = "Region for the Provider"
  type = string
}

variable "name" {
  description = "the name of the env"
  type = string
}

variable "availability_zones" {
  description = "the azs that the subnets will be spawned in"
  type = list(string)
}

variable "public_subnet_cidr" {
  description = "the subnet cidrs of the public subnets"
  type = list(string)
}

variable "private_subnet_cidr" {
  description = "the subnet cidrs of the private subnets"
  type = list(string)
}
