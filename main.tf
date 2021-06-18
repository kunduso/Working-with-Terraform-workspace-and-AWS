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