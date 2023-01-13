#!/bin/bash

# Prerequisite steps to create a Python Virtual Environment
# python3 -m venv .env
# source .env/bin/activate
# pip install -r requirements.txt

# cli style reports
checkov -f checkov.yaml --output cli --quiet --download-external-modules true --directory env/dev
checkov -f checkov.yaml --output cli --quiet --download-external-modules true --directory modules/api_gateway
checkov -f checkov.yaml --output cli --quiet --download-external-modules true --directory modules/kms
checkov -f checkov.yaml --output cli --quiet --download-external-modules true --directory modules/lambda
checkov -f checkov.yaml --output cli --quiet --download-external-modules true --directory modules/sns
checkov -f checkov.yaml --output cli --quiet --download-external-modules true --directory modules/step_functions
checkov -f checkov.yaml --output cli --quiet --download-external-modules true --directory modules/vpc