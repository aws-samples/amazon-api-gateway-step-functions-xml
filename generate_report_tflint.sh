#!/bin/bash

tflint --init

tflint -c .tflint.hcl env/dev/main.tf
tflint -c .tflint.hcl modules/api_gateway/main.tf
tflint -c .tflint.hcl modules/kms/main.tf
tflint -c .tflint.hcl modules/lambda/main.tf
tflint -c .tflint.hcl modules/sns/main.tf
tflint -c .tflint.hcl modules/step_functions/main.tf
tflint -c .tflint.hcl modules/vpc/main.tf