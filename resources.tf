
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




