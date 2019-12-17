provider "aws" {
  version = "~> 2.0"
  region  = var.region
}

terraform {
  backend "s3" {}
}

locals {
  task_definition_path = format("task-definitions/%s.json", var.task_name)
}

resource "aws_ecs_task_definition" "main" {
  family                = var.task_name
  container_definitions = file(local.task_definition_path)
  requires_compatibilities = ["FARGATE"]
  cpu = var.cpu
  memory = var.memory
}
