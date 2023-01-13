output "lambda_action_arn" {
  value = module.lambda_action.lambda_function_arn
  description = "The ARN of Lambda action"
}