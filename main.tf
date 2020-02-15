/*terraform {
  backend "s3" {
    bucket                  = "hackaton-states"
    key                     = "tf.state"
    region                  = "eu-west-1"
  }
}*/

provider "aws" {
    profile =                 "${var.profile}"
    shared_credentials_file = "~/.aws/credentials"
    region =                  "${var.aws_region}"
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

resource "aws_s3_bucket" "scan-state" {
    bucket = "${var.s3_bucket}"
    acl    = "private"

    versioning {
      enabled = true
    }

server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
     }
    }
tags = {
    Name = "HackathonQ2-RikiTikiTavi team"
  }
}

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_server_scan.id
  tags = {
    Name  = "Scan Server IP"
    Owner = "Hakathon - Riki tiki tavi team"
  }
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "${var.key_name}"
  public_key = "${tls_private_key.example.public_key_openssh}"
}

resource "aws_instance" "my_server_scan" {
  ami                    = var.ami_id
  instance_type          = "t2.medium"
  vpc_security_group_ids = [aws_security_group.my_scaner.id]
  subnet_id = var.subnet_pub_C
  key_name = "${aws_key_pair.generated_key.key_name}"

  tags = {
    Name = "cloudsploit-demo-scanner"
  }
  user_data = <<-EOF
#! /bin/bash
sudo yum install -y epel-release curl git nano htop mailx zip yum-utils device-mapper-persistent-data lvm2 awscli
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce
sudo usermod -aG docker centos
sudo systemctl start docker
curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
sudo yum -y install nodejs
git clone https://github.com/cloudsploit/scans.git
cd scans/
echo "export AWS_ACCESS_KEY_ID=XX" >> /etc/profile
echo "export AWS_SECRET_ACCESS_KEY=XX" >> /etc/profile
echo "export AWS_DEFAULT_REGION=eu-west-1" >> /etc/profile
npm install
node index.js --csv=./out1full.csv
node index.js --compliance=hipaa --csv=./out2hipaa.csv
node index.js --compliance=pci --csv=./out3pci.csv
git clone https://github.com/cloudflare/flan.git
cd flan/
sudo chown -R centos:root /scans/flan/shared/ips.txt
sudo aws ec2 describe-instances --query "Reservations[*].Instances[*].PublicIpAddress" --output=text > /scans/flan/shared/ips.txt
docker image build -t flan_scan:1.0 .
sudo docker run -v $(pwd)/shared:/shared flan_scan:1.0 -sV -oX /shared/xml_files -oN - -v1 $@ --script=vulners/vulners.nse
cd scans/
zip -r scan.zip *.csv
echo "This is your security scan for account ${var.AWS_ACCESS_KEY_ID} " | mail -s "Cloudsploit SecScan" -a scan.zip farkhad.badalov@gmail.com
EOF
}

#find . -maxdepth 1 -type f -name "out*.csv" | sed 's!.*/!!'| zip scan.zip -@


resource "aws_security_group" "my_scaner" {
  name = "Cloudsploit-SGroup"
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
    Name = "HackathonQ2-RikiTikiTavi team"
  }
}