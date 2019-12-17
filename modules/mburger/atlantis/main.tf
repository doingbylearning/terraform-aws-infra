provider "aws" {
  version = "~> 2.0"
  region  = var.region
}

terraform {
  backend "s3" {}
}

resource "aws_security_group" "main" {
  name        = format("%s-atlantis", var.name)
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "all" {
  type            = "ingress"
  from_port       = 0
  to_port         = 65535
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = aws_security_group.main.id
}

resource "aws_iam_role" "main" {
  name = format("%s-atlantis-iam-role", var.name)

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy" "main" {
  name = format("%s-atlantis-main", var.name)
  role = aws_iam_role.main.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "main" {
  name = format("%s-atlantis-iam-profile", var.name)
  role = aws_iam_role.main.name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "main" {
  ami                    = "ami-0ed9094b5d88a4537"
  source_dest_check      = false
  instance_type          = "c5.xlarge"
  subnet_id              = var.subnet_ids[0]
  key_name               = var.key_name
  vpc_security_group_ids = ["${aws_security_group.main.id}"]
  monitoring             = false
  iam_instance_profile   = aws_iam_instance_profile.main.name
  associate_public_ip_address = true

  root_block_device {
    volume_type = "gp2"
    volume_size = "20"
  }

  tags = {
    Name = format("%s-atlantis", var.name)
  }
}
