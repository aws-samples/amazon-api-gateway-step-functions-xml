variable "region" {
  description = "Default region for provider"
  type        = string
}

variable "partition" {
  description = "Default AWS partition"
  type        = string
}

variable "account" {
  description = "Default AWS account"
  type        = string
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "project" {
  description = "Project base name"
  type        = string
}

variable "sfn_failure_sns_topic_arn" {
  type = string
  description = "The ARN of the SNS topic to notify when an execution failure occurs"
}

variable "sfn_timeout" {
  type = number
  description = "The timeout for the ECS Task in seconds.  If the task execution exceeds this timeout it shall be terminated"
}

variable "sfn_job_max_attempts" {
  type = number
  description = "The maximum number of time a failed task shall be retried before failing permanently"
  default = 3
}

variable "sfn_job_retry_interval" {
  type = number
  description = "The interval in seconds before retrying the execution of a failed task"
  default = 30
}

variable "sfn_job_backoff_rate" {
  type = number
  description = "The multiplier by which the retry interval increases during each attempt (2.0 by default)"
  default = 2.0
}

variable "lambda_action_arn" {
  description = "The ARN of Lambda"
  type        = string
}

variable "kms_key_arn" {
  description = "The ARN of the kms key used to secure the db secret"
  type        = string
}

variable "kms_key_id" {
  description = "The id of the kms key used to secure the db secret"
  type        = string
}

variable "tags" {
  description = "AWS Tags to associate with resources"
  type = map(string)
  default = {}
}