provider "aws" {
    profile =                 "${var.profile}"
    shared_credentials_file = "~/.aws/credentials"
    region =                  "${var.aws_region}"
}

resource "aws_iam_user" "cloudsploit" {
  #count = "${length(var.username)}"
  name = "${var.username}"
  #${element(var.username,count.index )}
}

resource "aws_iam_access_key" "cloudsploit" {
  user = "${aws_iam_user.cloudsploit.name}"
  #pgp_key = "keybase:cloudsploit"
}

resource "aws_iam_user_policy_attachment" "cloudsploit" {
  #name = "cloudsploit_iam_policy"
  user = "${aws_iam_user.cloudsploit.name}"
  policy_arn = "${var.security_audit_arn}" 
}

/*
resource "aws_s3_bucket" "logbucket" {
  bucket = "${var.s3_bucket}"
  acl    = "private"

  tags = {
    Name        = "Log-bucket"
    Environment = "Dev"
  }
}
*/

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_server_scan.id
  tags = {
    Name  = "Scan Server IP"
    Owner = "Hakathon - Riki tiki tavi team"
  }
}

data "aws_vpc" "selected" {
  id = "${var.vpc_id}"
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
  ami                    = "${var.ami_id}"
  instance_type          = "t2.small"
  vpc_security_group_ids = [aws_security_group.my_scaner.id]
  subnet_id = "${var.subnet_pub_C}"
  key_name      = "${aws_key_pair.generated_key.key_name}"

  tags = {
    Name = "cloudsploit-demo-scanner"
  }
  #depends_on = [aws_instance.my_server_scan.id]
  #user_data              = file("user_data.sh")
  user_data = <<-EOF
#! /bin/bash
sudo yum install -y epel-release curl git nano htop mailx zip
curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
sudo yum -y install nodejs
git clone https://github.com/cloudsploit/scans.git
cd scans/
export AWS_ACCESS_KEY_ID=XXXXXX
export AWS_SECRET_ACCESS_KEY=XXXXX
export AWS_DEFAULT_REGION=eu-west-1
npm install
node index.js --csv=./out1full.csv
node index.js --compliance=hipaa --csv=./out2hipaa.csv
node index.js --compliance=pci --csv=./out3pci.csv
zip -r scan.zip *.csv
echo "This is your security scan for account ${AWS_ACCESS_KEY_ID} " | mail -s "Cloudsploit SecScan" -a scan.zip farkhad.badalov@gmail.com
EOF
}

#find . -maxdepth 1 -type f -name "out*.csv" | sed 's!.*/!!'| zip scan.zip -@


resource "aws_security_group" "my_scaner" {
  name = "Cloudsploit-SGroup"
  vpc_id = "${var.vpc_id}"
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
    Name = "Hackathon-Q2"
  }
}
