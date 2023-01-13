terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

##################################################
# <START> KMS key
##################################################

resource "aws_kms_key" "secrets_key" {
  description             = "DB Secrets Key"
  deletion_window_in_days = 10
  tags = var.tags
}

# Add an alias to the key
resource "aws_kms_alias" "secrets_key_alias" {
  name          = "alias/${var.project}-${var.environment}-seckey"
  target_key_id = aws_kms_key.secrets_key.key_id
}

##################################################
# </END> KMS key
##################################################