variable "profile" {
  default = "hackathonq2"
}

variable "aws_region" {
  default = "eu-west-1"
}

variable "s3_bucket" {
  default = "logbucket-tf-test-c"
}
variable "key_name" {
  default = "ec2-cloudsploit-key"
}

variable "username" {
  type = "string"
  default = "cloudsploit"
}

variable "security_audit_arn" {
  type = "string"
  default = "arn:aws:iam::aws:policy/SecurityAudit"
}

variable "ami_id" {
  description = "AMI ID"
  default = "ami-192a9460"
}

variable "vpc_id" {
  default = "vpc-4b030a2e"
}

variable "subnet_pub_C" {
  description = "default VPC subnet"
  default = "subnet-65d2ca12"
}