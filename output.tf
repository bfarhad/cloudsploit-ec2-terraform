output "this_iam_user_name" {
  description = "The user's name"
  value       = aws_iam_user.cloudsploit.name
}

output "this_iam_user_arn" {
  description = "The ARN assigned by AWS for this user"
  value       = aws_iam_user.cloudsploit.arn
}

output "elastic_ip" {
  value = aws_eip.my_static_ip.public_ip
}

output "id" {
  value = aws_iam_access_key.cloudsploit.id
}

output "secret" {
  value = "aws_iam_access_key.cloudsploit.encrypted_secret"
}

output "aws_keypair_name" {
  value = "${aws_key_pair.generated_key.key_name}"
  }

output "keypair" {
  value = "${tls_private_key.example.private_key_pem}"
}

output "s3-bucket" {
  value = "aws_s3_bucket.scan-state.id"
}