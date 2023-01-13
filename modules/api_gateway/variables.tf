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

variable "tags" {
  description = "AWS Tags to associate with resources"
  type = map(string)
  default = {}
}

variable "description" {
  description = "Api Gateway Description"
  type        = string
}

variable "protocol" {
  description = "Api Gateway Protocol"
  type        = string
  default     = "HTTP"
}

variable "state_machine_arn" {
  description = "State Machine Arn"
  type        = string
}

variable "state_machine_role_arn" {
  description = "State Machine Role Arn"
  type        = string
}

variable "create_api_gateway" {
  description = "Whether to create API Gateway"
  type        = bool
  default     = true
}

variable "create_default_stage" {
  description = "Whether to create default stage"
  type        = bool
  default     = true
}

variable "create_default_stage_api_mapping" {
  description = "Whether to create default stage API mapping"
  type        = bool
  default     = true
}

variable "create_stage" {
  description = "Whether to create custom stage"
  type        = bool
  default     = false
}

variable "create_stage_api_mapping" {
  description = "Whether to create stage API mapping"
  type        = bool
  default     = false
}

variable "create_api_domain_name" {
  description = "Whether to create API domain name resource"
  type        = bool
  default     = true
}

variable "create_routes_and_integrations" {
  description = "Whether to create routes and integrations resources"
  type        = bool
  default     = true
}

variable "create_vpc_link" {
  description = "Whether to create VPC links"
  type        = bool
  default     = true
}