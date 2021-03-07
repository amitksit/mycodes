provider "aws" {
  profile = "default"
  shared_credentials_file = "~/credentials"
  region = "ap-south-1"
}

resource "aws_vpc" "first_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "prod_vpc"
  }
}

resource "aws_subnet" "first_subnet" {
  vpc_id     = aws_vpc.first_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "prod_subnet"
  }
}

resource "aws_vpc" "second_vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "dev_vpc"
  }
}

resource "aws_subnet" "second_subnet" {
  vpc_id     = aws_vpc.second_vpc.id
  cidr_block = "10.1.1.0/24"

  tags = {
    Name = "dev_subnet"
  }
}