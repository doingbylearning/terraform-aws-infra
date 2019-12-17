variable "region" {
  description = "Region for the Provider"
  type = string
}

variable "name" {
  description = "the name of the env"
  type = string
}

variable "task_name" {
  description = "the task name to deploy"
  type = string
}

variable "cpu" {
  description = "the cpu resources to alloc"
  type = string
}

variable "memory" {
  description = "the memory resources to alloc"
  type = string
}
