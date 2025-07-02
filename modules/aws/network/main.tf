/*───────────────────────────────────────────────────────────────
 *  AWS NETWORK MODULE
 *  - VPC CIDR            (ex.: 10.20.0.0/16)
 *  - 1× public subnet    (NAT/LB)
 *  - 1× private subnet   (EKS nodes)
 *──────────────────────────────────────────────────────────────*/

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, 0) # 10.20.0.0/20
  map_public_ip_on_launch = true
  availability_zone = "${var.region}a"
  tags = {
    Name = "${var.vpc_name}-public"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, 1) # 10.20.16.0/20
  availability_zone = "${var.region}a"
  tags = {
    Name = "${var.vpc_name}-private"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
