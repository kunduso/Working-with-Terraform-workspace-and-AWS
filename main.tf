#Create VPC 
resource "aws_vpc" "myvpc" {
  cidr_block = lookup(var.vpc_address_space, local.env)
  tags = {
    Name = local.env
  }
}
data "aws_availability_zones" "available" {
  state = "available"
}
resource "aws_subnet" "mysubnet" {
  count                   = length(lookup(var.subnet_address_space, local.env))
  cidr_block              = lookup(var.subnet_address_space, local.env)[count.index]
  vpc_id                  = aws_vpc.myvpc.id
  map_public_ip_on_launch = "true"
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${local.env}-subnet-${count.index + 1}"
  }
}
resource "aws_internet_gateway" "this_gateway" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    "Name" = "${local.env}-primary_gateway"
  }
}

resource "aws_route_table" "this_route_table" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this_gateway.id
  }
  tags = {
    "Name" = "${local.env}_primary_route_table"
  }
}

resource "aws_route_table_association" "public-rta" {
  count          = length(aws_subnet.mysubnet)
  subnet_id      = aws_subnet.mysubnet[count.index].id
  route_table_id = aws_route_table.this_route_table.id

}