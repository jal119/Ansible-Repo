resource "aws_security_group" "Jenkins_sg" {
  name        = "Jenkins-Security-Group"
  description = "Open 22,443,80,8080"

  dynamic "ingress" {
    for_each = [22, 80, 443, 8080]
    content {
      description      = "Allow ${ingress.value}"
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins-Security-Group"
  }
}

resource "aws_instance" "web" {
  ami                    = "ami-0fc5d935ebf8bc3bc"
  instance_type          = "t2.medium"
  key_name               = "New-linux-Key"
  vpc_security_group_ids = [aws_security_group.Jenkins_sg.id]
  user_data              = templatefile("./install_jenkins.sh", {})

  tags = {
    Name = "Jenkins-Sonar"
  }

  root_block_device {
    volume_size = 8
  }
}
