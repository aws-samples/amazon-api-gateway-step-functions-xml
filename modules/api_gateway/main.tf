terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

###################
# HTTP API Gateway
###################

resource "aws_api_gateway_rest_api" "_" {
  name           = "${var.project}-${var.environment}-api"
  api_key_source = "HEADER"

  body = templatefile("${path.module}/api.yaml", {
    title = "${var.project}-${var.environment}-api"
    description = var.description
    aws_region = var.region
    api_gateway_step_functions_role_arn = aws_iam_role.sfn_api_gateway_execution_role.arn
    state_machine_arn = var.state_machine_arn
  })

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = var.tags
}

resource "aws_api_gateway_deployment" "_" {
  rest_api_id = aws_api_gateway_rest_api._.id
  stage_name  = ""

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "_" {
  stage_name    = var.environment
  rest_api_id   = aws_api_gateway_rest_api._.id
  deployment_id = aws_api_gateway_deployment._.id

  xray_tracing_enabled = false

  tags = var.tags
}

resource "aws_api_gateway_method_settings" "_" {
  rest_api_id = aws_api_gateway_rest_api._.id
  stage_name  = aws_api_gateway_stage._.stage_name
  method_path = "*/*"

  settings {
    throttling_burst_limit = 100
    throttling_rate_limit  = 100
    metrics_enabled        = false
    # logging_level          = "INFO"
    data_trace_enabled     = false
  }
}

###########################################################################
# Step Function IAM Roles
###########################################################################
data "aws_iam_policy_document" "sfn_api_gateway_role_policy" {
  statement {
    effect                  = "Allow"
    principals {
      type                  = "Service"
      identifiers           = ["apigateway.amazonaws.com"]
    }
    actions                 = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "sfn_api_gateway_execution_policy" {
  statement {
    effect                  = "Allow"
    actions                 = [ "states:StartExecution", "states:StartSyncExecution" ]
    resources               = [ var.state_machine_arn ]
  }
}

resource "aws_iam_role" "sfn_api_gateway_execution_role" {
  name                      = "${var.project}-${var.environment}-sfnapigatewayexecrole"
  assume_role_policy        = data.aws_iam_policy_document.sfn_api_gateway_role_policy.json
  tags                      = var.tags
}

resource "aws_iam_role_policy" "sfn_execution_policy" {
  name                      = "${var.project}-${var.environment}-sfnapigatewayexecrolepolicy"
  role                      = aws_iam_role.sfn_api_gateway_execution_role.id
  policy                    = data.aws_iam_policy_document.sfn_api_gateway_execution_policy.json
}