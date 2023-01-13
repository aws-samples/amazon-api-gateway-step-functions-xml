{
  "Comment": "Step function that supports XML payload from API Gateway",
  "StartAt": "Execute XML Action",
  "States": {
    "Execute XML Action": {
      "Type": "Task",
      "InputPath": "$",
      "OutputPath": "$.actionStatus.Payload.body",
      "Resource": "arn:aws:states:::lambda:invoke",
      "Parameters": {
        "FunctionName": "${lambda_action_arn}",
        "Payload.$": "$"
      },
      "Retry": [
        {
          "ErrorEquals": [
            "Lambda.ServiceException",
            "Lambda.AWSLambdaException",
            "Lambda.SdkClientException"
          ],
          "IntervalSeconds": ${interval_seconds},
          "MaxAttempts": ${max_attempts},
          "BackoffRate": ${backoff_rate}
        }
      ],
      "Catch": [
          {
            "ErrorEquals": [ "States.ALL" ],
            "Next": "Send Failure Notification",
            "ResultPath": "$.error"
          }
      ],
      "TimeoutSeconds": ${timeout},
      "ResultPath": "$.actionStatus",
      "Next": "Was Action Successfull?"
    },
    "Was Action Successfull?": {
      "Type": "Choice",
      "InputPath": "$",
      "OutputPath": "$",
      "Choices": [
        {
          "Variable": "$.actionStatus",
          "StringEquals": "ERROR",
          "Next": "Send Failure Notification"
        }
      ],
      "Default": "Execution Success"
    },
    "Send Failure Notification": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "TopicArn": "${failure_sns_topic_arn}",
        "Subject": "Failed execution",
        "Message.$": "$.error",
        "MessageAttributes": {
          "Execution_Id": {
            "DataType": "String",
            "StringValue": "$$.Execution.Id"
          },
          "Execution_Start_Time": {
            "DataType": "String",
            "StringValue": "$$.Execution.StartTime"
          },
          "State_Machine_Id": {
            "DataType": "String",
            "StringValue": "$$.StateMachine.Id"
          }
        }
      },
      "Next": "Execution Failed"
    },
    "Execution Success": {
      "Type": "Succeed"
    },
    "Execution Failed": {
      "Type": "Fail"
    }
  }
}