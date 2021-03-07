provider "aws" {
  profile = "default"
  shared_credentials_file = "~/credentials"
  region = "ap-south-1"
}
# 1. Create vpc
resource "aws_vpc" "prod-vpc" {
  cidr_block = "10.0.0.0/16"
    tags = {
        Name = "production"
    }
}
# 2. Create Internet Gateway
resource "aws_internet_gateway" "prod_igw" {
  vpc_id = aws_vpc.prod_vpc.id
    tags = {
        Name = "production_igw"
    }
  }
}
# 3. Create Custom Route Table
resource "aws_route_table" "prod_rt" {
  vpc_id = aws_vpc.prod_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prod_igw
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_internet_gateway.prod_igw
  }

  tags = {
    Name = "prod_route_table"
  }
}
# 4. Create a Subnet
resource "aws_subnet" "prod_subnet" {
    vpc_id = aws_vpc.prod_vpc
    cidr_block = "10.0.1.0/24"
    availabiltiy_zone = "ap-south-1a"
    tags = {
        Name = production_subnet 
    }
}
# 5. Associate subnet with Route Table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.prod_subnet
  route_table_id = aws_route_table.prod_rt
}
# 6. Create Security Group to allow port 22 80 443
resource "aws_security_group" "prod_allow_web" {
  name        = "production_allow_web"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.prod_vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = 0.0.0.0/0
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = 0.0.0.0/0
  }  
  ingress {
    description = "SSH"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = 0.0.0.0/0
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web"
  }
}
# 7. Create a network interface with an ip in the subnet that was created in step 4
resource "aws_network_interface" "webserver_nic" {
  subnet_id       = aws_subnet.prod_subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.prod_allow_web.id]
}
# 8. Assign an elastic IP to the network interface created in step 7
resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.webserver_nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [aws_internet_gateway.prod_igw]
}
# 9. Create Ubuntu server and install/enable apache2
resource "aws_instance" "web-server-instance" {
    ami = "ami-0d758c1134823146a"
    instance_type = "t2.micro"
    availabiltiy_zone = "ap-south-1a"
    key_name = "mumbai_main_key"

    network_interface {
        device_index = 0
        network_interface_id = aws_network_interface.webserver_nic.id
    }

    user_data = <<-EOF
                #!/bin/bash
                sudo apt udpate -y
                sudo apt install apache2 -y
                sudo bash -c 'echo your very first web server > /var/www/html/index.html'
                EOF
                tags = {
                    Name = "web-server"
                }



}