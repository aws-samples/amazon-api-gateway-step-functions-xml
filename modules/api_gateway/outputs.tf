output "apigateway_arn" {
  description = "The API Gateway ARN"
  value       = aws_api_gateway_rest_api._.arn
}

output "apigateway_created_date" {
  description = "The API Gateway Created Date"
  value       = aws_api_gateway_rest_api._.created_date
}

output "apigateway_execution_arn" {
  description = "The API Gateway Execution ARN"
  value       = aws_api_gateway_rest_api._.execution_arn
}

output "apigateway_id" {
  description = "The API Gateway Identifier"
  value       = aws_api_gateway_rest_api._.id
}

output "apigateway_root_resource_id" {
  description = "The API Gateway Root Resource Identifier"
  value       = aws_api_gateway_rest_api._.root_resource_id
}