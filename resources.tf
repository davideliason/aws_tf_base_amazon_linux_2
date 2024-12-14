
# Create a VPC
# resource "aws_vpc" "example" {
# cidr_block = "10.0.0.0/16"
#}

resource "aws_vpc" "awstf5_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "awstf5_vpc"
  }
}

resource "aws_subnet" "awstf5_sn" {
  vpc_id            = aws_vpc.awstf5_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.awstf5_vpc.cidr_block, 3, 1)
  availability_zone = "us-west-2a"

  tags = {
    Name = "awstf5_sn"
  }
}

# IG
resource "aws_internet_gateway" "awstf5_ig" {
  vpc_id = aws_vpc.awstf5_vpc.id

  tags = {
    Name = "awstf5_ig"
  }
}

resource "aws_route_table" "awstf5_rt" {
  vpc_id = aws_vpc.awstf5_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.awstf5_ig.id
  }

  tags = {
    Name = "awstf5_rt"
  }
}

resource "aws_route_table_association" "awstf5_rt_assoc" {
  subnet_id      = aws_subnet.awstf5_sn.id
  route_table_id = aws_route_table.awstf5_rt.id
}

resource "aws_security_group" "awstf5_SG_ssh" {
  name        = "allow-all-ssh"
  description = "Allow all inbound traffic from port 22"
  vpc_id      = aws_vpc.awstf5_vpc.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "awstf5_SG_allow_ssh"
  }
}

resource "aws_key_pair" "id_rsa" {
  key_name   = "id_rsa"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCxXdTJ90DHCrcnFdfKZdDObZjixjoCCCKqLaBhAUlG5R3z1rkTrTtb4WlF4UPHDCSGc4GjqQPR+AYz1PmeJLA8SnbSBKn3YdGMmuB5cg11vF1t4LYhzZ1gCl1WMqKeEUFzuUVdUhak2PsbPBEHJIPPHIMSHY1KzCIHqr6jZRqZ2q9agFGKEMk+tMS7zZVncNWRfmy8jb9vgvuNBABZxdzrayUXxch1nrvE0oSWWrsQodORXNLj1no7LaSBstGW2EzSd8zVZiB4pJit4k7Cup2XyOJFsHpnsRqAO/CPlXIVlBcFAQO+UFxMvL3wbkwWxvlouWqXPznaH60oZrFQIzNS56RRsQyQyioz0bW2oHgFLDhYAiM2wuLEWBhs9pQtBCwp8SaZeSgzJ22S8muTUCP9tEVWe76PEKrgkf35Y194JlCPz0sNlJb+8wZToQTe63Uiqe+t43nai5V4lyOJwJDSZrTI9Z6jXjIXXSlSG+PARhsaanJL8P9QFjZo3WxSgTuoAe2WJsKcAYPH1oHPUN8jSHdmxpVdpJDnUGZwsza8YyBPolOCDrQsFUVkIAy1Y0gTuqpQp1XUyXqbbIZH7DRQQAslEmjIaTBmA8snZgX9kl4nHdVC9/qxqwGmZswYvt4o8AWf0HGrq7QRP8wTHu8AaUZBIDUXnOsL9bIiZm/l0Q== davide@Davids-MacBook-Air.local"
}
