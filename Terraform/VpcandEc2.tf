provider "aws" {
  region = "us-east-2"
}

# CREATE VPC
resource "aws_vpc" "project-vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "ProjectVPC"
    }
}

# CREATE 2 SUBNETS
resource "aws_subnet" "project-public_subent_01" {
    vpc_id = aws_vpc.project-vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-2a"
    tags = {
      Name = "project-public_subent_01"
    }
}

resource "aws_subnet" "project-public_subent_02" {
    vpc_id = aws_vpc.project-vpc.id
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-2b"
    tags = {
      Name = "project-public_subent_02"
    }
}


# CREATE INTERNET GATEWAY AND ASSOCIATE TO VPC
resource "aws_internet_gateway" "project-igw" {
    vpc_id = aws_vpc.project-vpc.id
    tags = {
      Name = "Project-IGW"
    }
}

// CREATE A ROUTE TABLE
resource "aws_route_table" "project-public-rt" {
    vpc_id = aws_vpc.project-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.project-igw.id
    }
    tags = {
      Name = "Project-RT"
    }
}

# ASSOCIATE ROUTE TABLE TO MY SUBNET

resource "aws_route_table_association" "project-subnet-1" {
    subnet_id = aws_subnet.project-public_subent_01.id
    route_table_id = aws_route_table.project-public-rt.id
}

resource "aws_route_table_association" "project-subent-2" {
    subnet_id = aws_subnet.project-public_subent_02.id
    route_table_id = aws_route_table.project-public-rt.id
}


# CREATE SECURITY GROUP
resource "aws_security_group" "project-sg" {
  name = "project-sg"
  description = "Security group for project services"
  vpc_id = aws_vpc.project-vpc.id

  ingress {
    description = "SSH Access"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins Access"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SonarQube Access"
    from_port = 9000
    to_port = 9000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Flask App Access"
    from_port = 5000
    to_port = 5000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}



# CREATING EC2
resource "aws_instance" "demo-server" {
    ami = "ami-0199d4b5b8b4fde0e"
    instance_type = "c7i-flex.large"
    key_name = "Jenkins_master"
    subnet_id = aws_subnet.project-public_subent_01.id
    for_each = toset(["Ansible", "Jenkins", "Docker"])
    tags = {
        Name = "${each.key}"
    }
    # security_groups = [ "project-sg" ]
    vpc_security_group_ids = [aws_security_group.project-sg.id]
}
