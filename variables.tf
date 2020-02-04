variable "s3_bucket" {
  default = "logbucket-tf-test-c"
}
variable "key_name" {
  default = "ec2-some-key"
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
  default = "vpc-XXXXXX"
}

variable "subnet_pub_C" {
  description = "Public Subnet C"
  default = "subnet-XXXX"
}