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

variable "kms_key_id" {
  description = "The id of the kms key used to secure the db secret"
  type        = string
}

variable "kms_key_arn" {
  description = "The ARN of the kms key used to secure the db secret"
  type        = string
}

variable "vpc_id" {
  type = string
  description = "The vpc id"
}

variable "vpc_private_subnets" {
  type = list(string)
  description = "The private subnets of the VPC"
}

variable "vpc_private_subnets_cidr_blocks" {
  description = "Vpc Private Subnets Cidr Block"
  type        = list(string)
}

variable "vpc_public_subnets_cidr_blocks" {
  description = "Vpc Public Subnets Cidr Block"
  type        = list(string)
}