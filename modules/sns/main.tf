terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

###########################################################################
# SNS Topic
###########################################################################
resource "aws_sns_topic" "notification" {
  name                  = "${var.project}-${var.environment}-failurenotifications"
  kms_master_key_id     = var.kms_key_id
  tags                  = var.tags
}