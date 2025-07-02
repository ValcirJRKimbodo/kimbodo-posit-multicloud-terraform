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
  for_each = toset(var.azs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, index(var.azs, each.key)) # /20 slices
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = { Name = "${var.vpc_name}-public-${each.key}" }
}

resource "aws_subnet" "private" {
  for_each = toset(var.azs)

  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, index(var.azs, each.key) + 8) # next /20 slices
  availability_zone = each.key

  tags = { Name = "${var.vpc_name}-private-${each.key}" }
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
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

