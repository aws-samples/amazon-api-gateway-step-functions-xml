variable "region" {
  description = "Default region for provider"
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

variable "api_description" {
  description = "Api Gateway Description"
  type        = string
}

variable "api_protocol" {
  description = "Api Gateway Protocol"
  type        = string
  default     = "HTTP"
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