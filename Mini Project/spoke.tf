resource "aws_internet_gateway" "spoke_igw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "spoke-igw"
    managed-by  = "Terraform"
    deployed-by = var.deployed_by
  }
}

resource "aws_subnet" "spoke_subnet_1" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "spoke-subnet-1"
    managed-by  = "Terraform"
    deployed-by = var.deployed_by
  }
}

resource "aws_subnet" "spoke_subnet_2" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.10.2.0/24"
  availability_zone       = "eu-west-2b"
  map_public_ip_on_launch = true

  tags = {
    Name        = "spoke-subnet-2"
    managed-by  = "Terraform"
    deployed-by = var.deployed_by
  }
}

resource "aws_route_table" "spoke_route_table" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.spoke_igw.id
  }

  tags = {
    Name        = "spoke-route-table"
    managed-by  = "Terraform"
    deployed-by = var.deployed_by
  }
}

resource "aws_route_table_association" "rta_1" {
  subnet_id      = aws_subnet.spoke_subnet_1.id
  route_table_id = aws_route_table.spoke_route_table.id
}

resource "aws_route_table_association" "rta_2" {
  subnet_id      = aws_subnet.spoke_subnet_2.id
  route_table_id = aws_route_table.spoke_route_table.id
}

resource "aws_security_group" "spoke_sg" {
  name        = "spoke-vm-sg"
  description = "Allow internet access for spoke VMs"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere (adjust for security)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name         = "Spoke VM SG"
    managed-by   = "Terraform"
    deployed-by  = var.deployed_by
  }
}

resource "aws_instance" "vm_1" {
  ami                    = "ami-0b9dd1f70861d4721" 
  instance_type          = "t3.nano"
  subnet_id              = aws_subnet.spoke_subnet_1.id
  vpc_security_group_ids = [aws_security_group.spoke_sg.id]
  associate_public_ip_address = true

  tags = {
    Name        = "spoke-vm-1"
    managed-by  = "Terraform"
    deployed-by = var.deployed_by
  }
}

resource "aws_instance" "vm_2" {
  ami                    = "ami-0b9dd1f70861d4721"
  instance_type          = "t3.nano"
  subnet_id              = aws_subnet.spoke_subnet_2.id
  vpc_security_group_ids = [aws_security_group.spoke_sg.id]
  associate_public_ip_address = true

  tags = {
    Name        = "spoke-vm-2"
    managed-by  = "Terraform"
    deployed-by = var.deployed_by
  }
}