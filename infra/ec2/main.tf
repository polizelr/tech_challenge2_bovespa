resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh_mle"
  description = "Allow SSH access"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.micro"
  key_name      = "ec2_fiap"
  security_groups = [aws_security_group.allow_ssh.name]

  provisioner "file" {
    source      = "${path.module}/../../scripts/scraping.py"
    destination = "/home/ubuntu/scraping.py"
  }

  user_data = file("user_data.sh")

  tags = {
    Name = "ec2_mle_fiap"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/ec2_fiap.pem")
    host        = self.public_ip
  }
}