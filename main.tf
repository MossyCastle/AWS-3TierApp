/*  3 tier aplication */
provider "aws" {
  version = "~> 2.0"
  region  = var.region
}

resource aws_vpc "3T-App" {
  cidr_block           = var.address_space
  enable_dns_hostnames = true

  tags = {
    Name = "${var.prefix}-vpc"
  }
}

resource aws_subnet "3T-App" {
  vpc_id     = aws_vpc.hashicat.id
  cidr_block = var.subnet_prefix

  tags = {
    name = "${var.prefix}-subnet"
  }
}

resource aws_security_group "3T-App" {
  name = "${var.prefix}-security-group"

  vpc_id = aws_vpc.hashicat.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.prefix}-security-group"
  }
}

resource random_id "app-server-id" {
  prefix = "${var.prefix}-hashicat-"
  byte_length = 8
}

resource aws_internet_gateway "hashicat" {
  vpc_id = aws_vpc.hashicat.id

  tags = {
    Name = "${var.prefix}-internet-gateway"
  }
}
