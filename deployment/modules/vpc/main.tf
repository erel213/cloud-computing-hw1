resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"

    tags = {
      Name = "main-vpc"
    }
}

resource "aws_internet_gateway" "main-gw" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "main-igw"
    }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main-gw.id
    }

    tags = {
        Name = "Public route table"
    }
}

resource "aws_subnet" "public-1" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "eu-west-1a"

    tags = {
        Name = "Public subnet"
    }
}

resource "aws_subnet" "public-2" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "eu-west-1b"

    tags = {
        Name = "Public subnet"
    }
}

resource "aws_route_table_association" "public-1" {
    subnet_id = aws_subnet.public-1.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-2" {
    subnet_id = aws_subnet.public-2.id
    route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "eu-west-1b"

    tags = {
      Name = "Private subnet"
    }
}