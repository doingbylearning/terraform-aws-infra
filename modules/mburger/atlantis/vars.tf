variable "region" {
  description = "Region for the Provider"
  type = string
}

variable "name" {
  description = "the name of the env"
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "key_name" {
  type = string
}
