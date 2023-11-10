terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>5.24.0"
    }
  }
  required_version = "~>v1.5.7"
}

provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-arm64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

locals {
  public_key = file(var.ssh_public_key_path)
  private_key = file(var.ssh_private_key_path)
}

resource "aws_key_pair" "main" {
  key_name   = "main"
  public_key = local.public_key
}

resource "aws_instance" "main" {
  ami           = data.aws_ami.ubuntu.image_id
  key_name      = aws_key_pair.main.key_name
  instance_type = "t4g.nano"

  provisioner "remote-exec" {
    script = "${path.module}/scripts/script.sh"
  }

  provisioner "file" {
    source      = "${path.module}/html"
    destination = "/tmp/"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/html/* /var/www/html/"
    ]
  }

  connection {
    private_key = local.private_key
    host        = self.public_ip
    type        = "ssh"
    user        = "ubuntu"
  }
}

output "public_ip" {
  value = aws_instance.main.public_ip
}
