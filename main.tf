# create vpc:
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    "Name" = "my_vpc"
  }
}

# data call for availability zones:
data "aws_availability_zones" "az" {
  state = "available"
}

# create public subnets:
resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnets_cidr_blocks)
  availability_zone       = count.index % 2 == 0 ? data.aws_availability_zones.az.names[0] : data.aws_availability_zones.az.names[1]
  cidr_block              = var.public_subnets_cidr_blocks[count.index]
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.vpc.id

  tags = {
    Name = "my_public_subnet${count.index + 1}_${data.aws_availability_zones.az.names[count.index]}"
  }
}

# create private subnets:
resource "aws_subnet" "private_subnet" {
  count                   = length(var.private_subnets_cidr_blocks)
  availability_zone       = count.index % 2 == 0 ? data.aws_availability_zones.az.names[0] : data.aws_availability_zones.az.names[1]
  cidr_block              = var.private_subnets_cidr_blocks[count.index]
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.vpc.id

  tags = {
    Name = "my_private_subnet${count.index + 1}_${data.aws_availability_zones.az.names[count.index]}"
  }
}

# create igw:
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "my_igw"
  }
}

# create natgw:
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.natgw_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id
  depends_on    = [aws_eip.natgw_eip]

  tags = {
    Name = "my_natgw"
  }
}

# create eip for natgw:
resource "aws_eip" "natgw_eip" {
  vpc = true

  tags = {
    Name = "my_eip"
  }
}

# create public route table:
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "my_public_route_table"
  }
}

# create private route table:
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name = "my_private_route_table"
  }
}

# associate public route table with public subnets:
resource "aws_route_table_association" "public_route_table_association" {
  count          = length(var.public_subnets_cidr_blocks)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

# associate private route table with private subnets:
resource "aws_route_table_association" "private_route_table_association" {
  count          = length(var.private_subnets_cidr_blocks)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}
