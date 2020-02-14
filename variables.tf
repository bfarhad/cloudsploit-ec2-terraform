variable "s3_bucket" {
  default = "logbucket-tf-test-c"
}

variable "username" {
  type = string
  default = "cloudsploit"
}

variable "security_audit_arn" {
  type = string
  default = "arn:aws:iam::aws:policy/SecurityAudit"
}

variable "ami_id" {
  description = "AMI ID"
  default = "ami-192a9460"
}

variable "key_name" { }

variable "vpc_id" { }

variable "subnet_pub_C" { }

variable "AWS_ACCESS_KEY_ID" { }

variable "AWS_SECRET_ACCESS_KEY" { }

