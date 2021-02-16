provider "aws" {
  region = "ap-south-1"
  profile = "default"
  shared_credentials_file = "~/.aws/credentials"
}
//This is a string variable
variable "firststring" {
  type = "string"
  default = "This is my first string"
}

output "myfirstoutput" {
  value = "${var.firststring}"
}