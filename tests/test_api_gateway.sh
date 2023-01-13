#!/bin/bash

# simulate a HTTP client and send an XML payload to the AWS API Gateway endpoint
ROOT_DIR="${PWD}"
AWS_REGION="eu-central-1"

cd "${ROOT_DIR}/env/dev"
API_GATEWAY_URL=$(terraform output -raw apigateway_id)

cd "${ROOT_DIR}"

echo "#######################################"
echo ""
echo "AWS Region: ${AWS_REGION}"
echo ""
echo "API Gatewayt Endpoint:"
echo ""
echo "https://${API_GATEWAY_URL}.execute-api.${AWS_REGION}.amazonaws.com/dev/invoke"
echo ""
echo "#######################################"

curl -X POST https://${API_GATEWAY_URL}.execute-api.${AWS_REGION}.amazonaws.com/dev/invoke \
  -H "Content-Type: application/xml" \
  -H "Accept: application/xml" \
  -d @"tests/example.xml"