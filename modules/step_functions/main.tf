terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.1"
    }
  }
}

###########################################################################
# Step Function
###########################################################################
resource "aws_cloudwatch_log_group" "step_functions_log_group" {
  name = "/aws/vendedlogs/${var.project}-${var.environment}-actions-invoker"
}

resource "aws_sfn_state_machine" "sfn_state_machine" {
  name                      = "${var.project}-${var.environment}-actions-invoker"
  depends_on                = [ null_resource.delay ]
  role_arn                  = aws_iam_role.sfn_execution_role.arn
  logging_configuration {
    log_destination         = "${aws_cloudwatch_log_group.step_functions_log_group.arn}:*"
    include_execution_data  = false
    level                   = "ALL"
  }
  definition                = templatefile("${path.module}/definitions/state-machine-definition.json.tpl", {
    lambda_action_arn                 = var.lambda_action_arn
    timeout                             = tostring(var.sfn_timeout)
    interval_seconds                    = tostring(var.sfn_job_retry_interval)
    max_attempts                        = tostring(var.sfn_job_max_attempts)
    backoff_rate                        = tostring(var.sfn_job_backoff_rate)
    failure_sns_topic_arn               = var.sfn_failure_sns_topic_arn
  })
  type                      = "EXPRESS"
  tags = var.tags
}

# there is a bug in terraform (https://github.com/terraform-providers/terraform-provider-aws/issues/7893) which is close to being fixed: https://github.com/terraform-providers/terraform-provider-aws/pull/12005
# this is a workaround....
resource "null_resource" "delay" {
  provisioner "local-exec" {
    command                  = "sleep 15"
  }
  depends_on                 = [ aws_iam_role.sfn_execution_role, aws_iam_role_policy.sfn_execution_policy ]
  triggers = {
    "states_exec_role"       = aws_iam_role.sfn_execution_role.arn
  }
}

###########################################################################
# Step Function IAM Roles
###########################################################################
data "aws_iam_policy_document" "sfn_role_policy" {
  statement {
    effect                  = "Allow"
    principals {
      type                  = "Service"
      identifiers           = ["states.amazonaws.com"]
    }
    actions                 = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "sfn_execution_policy" {
  statement {
    effect                  = "Allow"
    actions                 = [ "sns:Publish" ]
    resources               = [ var.sfn_failure_sns_topic_arn ]
  }
  statement {
    effect                  = "Allow"
    actions                 = [ "lambda:InvokeFunction" ]
    resources               = [ var.lambda_action_arn ]
  }
  statement {
    effect                  = "Allow"
    actions                 = [ 
      "logs:CreateLogDelivery",
      "logs:GetLogDelivery",
      "logs:UpdateLogDelivery",
      "logs:DeleteLogDelivery",
      "logs:ListLogDeliveries",
      "logs:PutLogEvents",
      "logs:PutResourcePolicy",
      "logs:DescribeResourcePolicies",
      "logs:DescribeLogGroups" 
    ]
    resources               = [ "*" ]
  }
}

resource "aws_iam_role" "sfn_execution_role" {
  name                      = "${var.project}-${var.environment}-sfnexecutionrole"
  assume_role_policy        = data.aws_iam_policy_document.sfn_role_policy.json
  tags                      = var.tags
}

resource "aws_iam_role_policy" "sfn_execution_policy" {
  name                      = "${var.project}-${var.environment}-sfnexecutionrolepolicy"
  role                      = aws_iam_role.sfn_execution_role.id
  policy                    = data.aws_iam_policy_document.sfn_execution_policy.json
}

resource "aws_kms_grant" "sfn_kms_grant" {
  name              = "sfn-kms-grant"
  key_id            =  var.kms_key_id
  grantee_principal = aws_iam_role.sfn_execution_role.arn
  operations        = ["Encrypt", "Decrypt", "GenerateDataKey"]
}