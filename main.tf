resource "aws_vpc" "adi_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "dev-vpc"
  }
}

resource "aws_subnet" "adi_subnet" {
  vpc_id                  = aws_vpc.adi_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "dev-public"
  }
}

resource "aws_internet_gateway" "adi_igw" {
  vpc_id = aws_vpc.adi_vpc.id

  tags = {
    Name = "dev-igw"
  }
}

resource "aws_route_table" "adi_route_table" {
  vpc_id = aws_vpc.adi_vpc.id

  tags = {
    Name = "dev-route-table"
  }
}

resource "aws_route" "adi_default_route" {
  route_table_id         = aws_route_table.adi_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.adi_igw.id
}

resource "aws_route_table_association" "adi_subnet_association" {
  subnet_id      = aws_subnet.adi_subnet.id
  route_table_id = aws_route_table.adi_route_table.id
}

resource "aws_security_group" "adi_sg" {
  name        = "dev-sg"
  description = "Security group for development"
  vpc_id      = aws_vpc.adi_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.local_ip}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "adi_key_pair" {
  key_name   = "adi-key-pair"
  public_key = file("${var.key_path}/${var.key_name}.pub")
}

resource "aws_instance" "dev_node" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.server_ami.id
  key_name               = aws_key_pair.adi_key_pair.key_name
  subnet_id              = aws_subnet.adi_subnet.id
  vpc_security_group_ids = [aws_security_group.adi_sg.id]
  user_data              = file("templates/userdata.tpl")

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "dev-node"
  }

  // This section is used to update our local SSH configuration file with the public IP of the instance.
  // This file will not be affected by Terraform destroy command and will need to be manually deleted.
  provisioner "local-exec" {
    command = templatefile("templates/${var.host_os}-ssh-config.tpl", { 
        hostname = self.public_ip
        user      = "ubuntu"
        identityfile = "~/.ssh/aws_key"
    })
    interpreter = var.host_os == "windows" ? ["powershell", "-Command"] : ["bash", "-c"]
  }
}