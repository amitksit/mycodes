provider "aws" {
  region = "ap-south-1"
  profile = "default"
  shared_credentials_file = "~/.aws/credentials"
}

resource "aws_instance" "my-first-server" {
  ami           = "ami-0d758c1134823146a"
  instance_type = "t2.micro"

  tags = {
    Name = "ubuntu-Server"
  }
}

/* resource "<provider>_<resource_type>" "name" {
  config option....
  key = "value"
  key2 = "value"
} */
