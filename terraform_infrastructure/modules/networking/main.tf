
resource "aws_vpc" "projectVPC" {
  cidr_block           = var.cidr_block_range
  enable_dns_hostnames = var.hostnames_enabled
  enable_dns_support   = var.dns_allowed

  tags = {
    Environment = "${var.environment}"
    Name = "${var.vpc_name}-vpc"
  }
}

resource "aws_subnet" "public-subnets" {
  count             = length(var.public_subnets_cidr)
  vpc_id            = aws_vpc.projectVPC.id
  cidr_block        = var.public_subnets_cidr[count.index]
  availability_zone = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = true

  tags = {
    Name        = "Public Subnet-${var.environment}-${count.index + 1}"

    Environment = "${var.environment}"
  }
}

resource "aws_subnet" "private-subnets" {
  vpc_id            = aws_vpc.projectVPC.id
  count             = length(var.private_subnets_cidr)
  cidr_block        = var.private_subnets_cidr[count.index]
  availability_zone = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = false
  tags = {
    Name        = "Private Subnet-${var.environment}-${count.index + 1}"
    Environment = "${var.environment}"
  }
}

resource aws_internet_gateway "proj-igw" {
  vpc_id = aws_vpc.projectVPC.id

   tags = {
    Name        = "${var.environment}-project-igw"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table" "publicRT" {
    vpc_id = aws_vpc.projectVPC.id
     route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.proj-igw.id

 }
    tags = {
    Name        = "${var.environment}-public-route-table"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table_association" "public_association" {
  count = length(aws_subnet.public-subnets[*])
  route_table_id = aws_route_table.publicRT.id
  subnet_id = aws_subnet.public-subnets[count.index].id
}

resource "aws_route" "public_internet_gateway" {
 route_table_id         = aws_route_table.publicRT.id
 destination_cidr_block = "0.0.0.0/0"
 gateway_id             = aws_internet_gateway.proj-igw.id
}

resource "aws_eip" "nat_eip" {
  depends_on = [aws_internet_gateway.proj-igw]
} 



resource "aws_nat_gateway" "nat-gateway" {
  connectivity_type = var.connectivity_type
  subnet_id         = "${element(aws_subnet.public-subnets.*.id, 0)}"
  allocation_id =   aws_eip.nat_eip.id
  tags = {
    Name = "${var.environment}-nat-gateway"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table" "privateRT" {
  vpc_id = aws_vpc.projectVPC.id
  tags = {
    Name        = "${var.environment}-private-route-table"
    Environment = "${var.environment}"
  }
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.privateRT.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat-gateway.id
}

resource "aws_route_table_association" "private" {
  count  = length(aws_subnet.private-subnets[*])
  route_table_id = aws_route_table.privateRT.id
  subnet_id = aws_subnet.private-subnets[count.index].id

}









