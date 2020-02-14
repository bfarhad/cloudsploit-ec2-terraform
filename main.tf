terraform {
  backend "s3" {
    bucket                  = "hackaton-states"
    key                     = "tf.state"
    region                  = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
  version = "~> 2.49"
}

resource "aws_iam_user" "cloudsploit" {
  name = var.username
}

resource "aws_iam_access_key" "cloudsploit" {
  user = aws_iam_user.cloudsploit.name
}

resource "aws_iam_user_policy_attachment" "cloudsploit" {
  user = aws_iam_user.cloudsploit.name
  policy_arn = var.security_audit_arn
}

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_server_scan.id
  tags = {
    Name  = "Scan Server IP"
    Owner = "Farhad Badalov"
  }
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}


resource "aws_instance" "my_server_scan" {
  ami                    = var.ami_id
  instance_type          = "t2.medium"
  vpc_security_group_ids = [aws_security_group.my_scaner.id]
  subnet_id = var.subnet_pub_C
  key_name = var.key_name

  tags = {
    Name = "cloudsploit-demo-scanner"
  }
  user_data = <<-EOF
#! /bin/bash
sudo yum install -y epel-release curl git nano htop
curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
sudo yum -y install nodejs
git clone https://github.com/cloudsploit/scans.git
cd scans/
npm install
node index.js --csv=./out1full.csv
node index.js --compliance=hipaa --csv=./out2hipaa.csv
node index.js --compliance=pci --csv=./out3pci.csv
EOF
}


resource "aws_security_group" "my_scaner" {
  name = "My Security Group"
  vpc_id = var.vpc_id
  dynamic "ingress" {
    for_each = ["80", "443", "22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "My SecurityGroup"
  }
}