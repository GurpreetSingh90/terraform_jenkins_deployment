
resource "aws_vpc" "main" {
  cidr_block       = "10.10.0.0/20"
  instance_tenancy = "default"
  tags = {
    Name = "mainVpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public"
  }
}


resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.2.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "private"
  }
}

resource "aws_internet_gateway" "main_igw" {
  tags = {
    Name = "main_igw"
  }
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public_route" {
  tags = {
    Name = "public_route"
  }
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }
}

resource "aws_route_table_association" "public_route_aso" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table" "private_route" {
  tags = {
    Name = "private_route",
  }
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "private_route" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_route.id
}

output "vpc_id" {
    value = aws_vpc.main.id
    description = "VPC ID"
}

output "private_subnet" {
    value = aws_subnet.private.id
    description = "AWS Private Subnet"
}

output "public_subnet" {
    value = aws_subnet.public.id
    description = "AWS Public Subnet"
}

