provider "aws" {
  profile = "default"
  shared_credentials_file = "~/credentials"
  region = "ap-south-1"
}

resource "aws_instance" "my_first_tf_instance" {
  ami = "ami-0231704d6e7036502"
  instance_type = "t2.micro"
}