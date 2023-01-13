output "state_machine_id" {
  description = "The id of the Step Function"
  value       = element(concat(aws_sfn_state_machine.sfn_state_machine.*.id, [""]), 0)
}

output "state_machine_arn" {
  description = "The ARN of the Step Function"
  value       = element(concat(aws_sfn_state_machine.sfn_state_machine.*.arn, [""]), 0)
}

output "state_machine_creation_date" {
  description = "The date the Step Function was created"
  value       = element(concat(aws_sfn_state_machine.sfn_state_machine.*.creation_date, [""]), 0)
}

output "state_machine_status" {
  description = "The current status of the Step Function"
  value       = element(concat(aws_sfn_state_machine.sfn_state_machine.*.status, [""]), 0)
}

# IAM Role
output "role_arn" {
  description = "The ARN of the IAM role created for the Step Function"
  value       = element(concat(aws_iam_role.sfn_execution_role.*.arn, [""]), 0)
}

output "role_name" {
  description = "The name of the IAM role created for the Step Function"
  value       = element(concat(aws_iam_role.sfn_execution_role.*.name, [""]), 0)
}