resource "aws_vpc" "openstack_lab_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "OpenStackLabVPC"
  }
}

resource "aws_subnet" "management_subnet" {
  vpc_id            = aws_vpc.openstack_lab_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.preferred_az

  tags = {
    Name = "ManagementSubnet"
  }
}

resource "aws_route_table" "management_public_rt" {
  vpc_id = aws_vpc.openstack_lab_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "ManagementPublicRouteTable"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.openstack_lab_vpc.id

  tags = {
    Name = "OpenStackLabIGW"
  }
}

resource "aws_subnet" "neutron_external_subnet" {
  vpc_id            = aws_vpc.openstack_lab_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.preferred_az

  tags = {
    Name = "NeutronExternalSubnet"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.openstack_lab_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "NeutronPublicRouteTable"
  }
}




resource "aws_route_table_association" "management_subnet_assoc" {
  subnet_id      = aws_subnet.management_subnet.id
  route_table_id = aws_route_table.management_public_rt.id
}

resource "aws_route_table_association" "a_neutron_external" {
  subnet_id = aws_subnet.neutron_external_subnet.id
  #subnet_id      = aws_subnet.management_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

