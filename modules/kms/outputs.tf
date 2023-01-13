output "kms_key_id" {
  value = aws_kms_key.secrets_key.id
  description = "KMS Key Id"
}

output "kms_key_arn" {
  value = aws_kms_key.secrets_key.arn
  description = "KMS Key Arn"
}