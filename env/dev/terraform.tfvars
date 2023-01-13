###################################################
# Generic values that are passed to all modules
###################################################
region                              = "eu-central-1"
environment                         = "dev"
project                             = "aws-api-gateway-step-functions-xml"
tags = {
    "Project": "aws-api-gateway-step-functions-xml",
    "Environment": "dev"
}

###################################################
# API Gateway values (modules/api_gateway)
###################################################
api_description                     = "my awesome XML enabled AWS api"
api_protocol                        = "HTTP"
create_api_gateway                  = true
create_api_domain_name              = false
create_default_stage                = false
create_default_stage_api_mapping    = false
create_routes_and_integrations      = false