provider "aws" {
  profile = "default"
  shared_credentials_file = "~/credentials"
  region = "ap-south-1"
}

resource "aws_instance" "my_first_tf_instance" {
  ami = "ami-0db0b3ab7df22e366"
  instance_type = "t2.micro"
}