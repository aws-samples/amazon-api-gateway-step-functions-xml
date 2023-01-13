#!/bin/bash

###################################################################
# Script Name	: pre_tf_init.sh
# Description	: Script to be executed prior to running terraform init
#                 in order to perform pre initialization tasks
# Args          :
# Author       	: Damian McDonald
###################################################################

BASE_DIR="${PWD}"
LAMBDA_RESOURCE_DIR="modules/lambda/resources"
LAMBDA_ACTION_DIR="${LAMBDA_RESOURCE_DIR}/Action/src/Action"

# package Action lambda for deployment
cd "${BASE_DIR}"
cd "${LAMBDA_ACTION_DIR}"
echo "Build directory is: ${LAMBDA_ACTION_DIR}"
dotnet lambda package