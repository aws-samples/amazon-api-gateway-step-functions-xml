terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {

  # Make it faster by skipping something
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true

  # skip_requesting_account_id should be disabled to generate valid ARN in apigatewayv2_api_execution_arn
  skip_requesting_account_id = false

  region = var.region
}

data "aws_region" "current" {}
data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

##################################################
# <START> Networking
##################################################

module "vpc" {
  source        = "../../modules/vpc"
  region        = data.aws_region.current.name
  partition     = data.aws_partition.current.partition
  account       = data.aws_caller_identity.current.account_id
  environment   = var.environment
  project       = var.project
  tags          = var.tags
}

##################################################
# </END> Networking
##################################################


##################################################
# <START> Encryption
##################################################

module "kms" {
  source        = "../../modules/kms"
  region        = data.aws_region.current.name
  partition     = data.aws_partition.current.partition
  account       = data.aws_caller_identity.current.account_id
  environment   = var.environment
  project       = var.project
  tags          = var.tags
}

##################################################
# </END> Encryption
##################################################


##################################################
# <START> Notifications
##################################################

module "sns" {
  source        = "../../modules/sns"
  region        = data.aws_region.current.name
  partition     = data.aws_partition.current.partition
  account       = data.aws_caller_identity.current.account_id
  environment   = var.environment
  project       = var.project
  kms_key_id    = module.kms.kms_key_id
  tags          = var.tags
}

##################################################
# </END> Notifications
##################################################

##################################################
# <START> Lambda Actions
##################################################

module "lambda_actions" {
  source                = "../../modules/lambda"
  region                = data.aws_region.current.name
  partition             = data.aws_partition.current.partition
  account               = data.aws_caller_identity.current.account_id
  environment           = var.environment
  project               = var.project
  kms_key_arn           = module.kms.kms_key_arn
  kms_key_id            = module.kms.kms_key_id
  vpc_id                = module.vpc.vpc_id
  vpc_private_subnets   = module.vpc.private_subnets
  vpc_private_subnets_cidr_blocks     = module.vpc.private_subnets_cidr_blocks
  vpc_public_subnets_cidr_blocks      = module.vpc.public_subnets_cidr_blocks
}

##################################################
# <START> Lambda Actions
##################################################


##################################################
# <START> Step Functions
##################################################

module "step_functions" {
  source                                = "../../modules/step_functions"
  region                                = data.aws_region.current.name
  partition                             = data.aws_partition.current.partition
  account                               = data.aws_caller_identity.current.account_id
  environment                           = var.environment
  project                               = var.project
  lambda_action_arn                     = module.lambda_actions.lambda_action_arn
  sfn_failure_sns_topic_arn             = module.sns.arn
  kms_key_arn                           = module.kms.kms_key_arn
  kms_key_id                            = module.kms.kms_key_id
  sfn_timeout                           = 600
  sfn_job_max_attempts                  = 3
  sfn_job_retry_interval                = 30
  sfn_job_backoff_rate                  = 2.0
  tags                                  = var.tags
}

##################################################
# </END> Step Functions
##################################################


##################################################
# <START> API Gateway
##################################################

module "api_gateway" {
  source                    = "../../modules/api_gateway"
  region                    = data.aws_region.current.name
  partition                 = data.aws_partition.current.partition
  account                   = data.aws_caller_identity.current.account_id
  environment               = var.environment
  project                   = var.project
  state_machine_arn         = module.step_functions.state_machine_arn
  state_machine_role_arn    = module.step_functions.role_arn
  description               = var.api_description
  protocol                  = var.api_protocol
  tags                      = var.tags

  # define what to create and  not created
  create_api_gateway                = var.create_api_gateway
  create_api_domain_name            = var.create_api_domain_name
  create_default_stage              = var.create_default_stage
  create_default_stage_api_mapping  = var.create_stage_api_mapping
  create_routes_and_integrations    = var.create_vpc_link
}

##################################################
# </END> API Gateway
##################################################
