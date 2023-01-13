terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

##################################################
# <START> Lambda Handler supporting resources
##################################################

resource "aws_security_group" "actions_security_group" {
  name        = "actions_lambda_access"
  description = "Allow Inbound and Outbound access for Sample Actions"
  vpc_id      = var.vpc_id

  ingress {
    description       = "Lambda Actions access VPC"
    from_port         = 0
    to_port           = 65535
    protocol          = "tcp"
    cidr_blocks       = var.vpc_private_subnets_cidr_blocks
  }

  egress {
    from_port         = 0
    to_port           = 65535
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
  }

  tags = var.tags
}

##################################################
# </END> Lambda Handler supporting resources
##################################################


##################################################
# <START> Lambda Handlers
##################################################

module lambda_action {
  source                  = "terraform-aws-modules/lambda/aws"
  version                 = "4.7.1"

  publish                 = true
  create_package          = false
  local_existing_package  = "${path.module}/resources/Action/src/Action/bin/Release/netcoreapp3.1/Action.zip"
  
  function_name = "xml-processor-action"
  handler       = "Action::Action.Function::FunctionHandler"
  runtime       = "dotnetcore3.1"

  ephemeral_storage_size = 512
  memory_size = 512
  timeout = 900

  vpc_security_group_ids =  [ aws_security_group.actions_security_group.id ]
  vpc_subnet_ids = var.vpc_private_subnets
  attach_network_policy  = true

  tags = var.tags
}

##################################################
# </END> Lambda Handlers
##################################################