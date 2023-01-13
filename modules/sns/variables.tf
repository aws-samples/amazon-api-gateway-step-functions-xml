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

variable "kms_key_id" {
  description = "KMS Key Id used for encrypting"
  type        = string
}

variable "tags" {
  description = "AWS Tags to associate with resources"
  type = map(string)
  default = {}
}