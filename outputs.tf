# get vpc id:
output "vpc_id" {
  value = aws_vpc.vpc.id
}

# get public subnets ids:
output "public_subnet_id" {
  value = aws_subnet.public_subnet[*].id
}

# get private subnets ids:
output "private_subnet_id" {
  value = aws_subnet.private_subnet[*].id
}

# get public route table id:
output "public_route_table_id" {
  value = aws_route_table.public_route_table.id
}

# get private route table id:
output "private_route_table_id" {
  value = aws_route_table.private_route_table.id
}

# get igw id:
output "igw_id" {
  value = aws_internet_gateway.igw.id
}

# get natgw id:
output "natgw_id" {
 value = aws_nat_gateway.natgw.id
}
