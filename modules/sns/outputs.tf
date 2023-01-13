output "id" {
  description = "The id of the SNS topic"
  value       = aws_sns_topic.notification.id
}

output "arn" {
  description = "The arn of the SNS topic"
  value       = aws_sns_topic.notification.arn
}