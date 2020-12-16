# network.tf

# Fetch AZs in the current region
data "aws_availability_zones" "available" {
}

resource "aws_vpc" "main" {
  cidr_block = "172.17.0.0/16"
  tags = {
    "Name" = "socialpie-vpc"
  }
}
/*
# Create var.az_count private subnets, each in a different AZ
resource "aws_subnet" "private" {
  count             = var.az_count
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.main.id
  tags = {
    "Name" = "Private"
  }
}
*/
# Create var.az_count public subnets, each in a different AZ
resource "aws_subnet" "public" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, var.az_count + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  tags = {
    "Name" = "public"
  }
}

# Internet Gateway for the public subnet
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "socialpie-gateway"
  }
}

# Route the public subnet traffic through the IGW
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
  
}
resource "aws_route" "add_vpc_peering_access" {
  route_table_id         = aws_vpc.main.main_route_table_id
  destination_cidr_block = "172.31.0.0/16"
  gateway_id             = aws_vpc_peering_connection.main_to_socialpie.id
  
}
resource "aws_route" "internet_access-default" {
  route_table_id         = "rtb-27a64f4f"
  destination_cidr_block = "172.17.0.0/16"
  vpc_peering_connection_id      = aws_vpc_peering_connection.main_to_socialpie.id
}

# Create a NAT gateway with an Elastic IP for each private subnet to get internet connectivity
resource "aws_eip" "gw" {
  count      = var.az_count
  vpc        = true
  depends_on = [aws_internet_gateway.gw]
  tags = {
    "Name" = "socialpie-igw"
  }
}

resource "aws_nat_gateway" "gw" {
  count         = var.az_count
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.gw.*.id, count.index)
  tags = {
    "Name" = "socialpie-nat-gateway"
  }
}
/*
# Create a new route table for the private subnets, make it route non-local traffic through the NAT gateway to the internet
resource "aws_route_table" "private" {
  count  = var.az_count
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "socialpie-private-route"
  }
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.gw.*.id, count.index)
  }
}

# Explicitly associate the newly created route tables to the private subnets (so they don't default to the main route table)
resource "aws_route_table_association" "private" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}
*/
resource "aws_vpc_peering_connection" "main_to_socialpie" {
  #peer_owner_id = var.peer_owner_id
  peer_vpc_id   = "vpc-1bfdf372"
  vpc_id        = aws_vpc.main.id 
  auto_accept   = true

  tags = {
    Name = "VPC Peering between foo and bar"
  }
}