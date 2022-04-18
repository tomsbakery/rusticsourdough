provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  # Make it faster
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true

  # skip_requesting_account_id should be disabled to generate valid ARN in apigatewayv2_api_execution_arn
  skip_requesting_account_id = false
}

module "lambda_layer_local" {
  source = "terraform-aws-modules/lambda/aws"

  create_layer = true

  layer_name          = "fresh_bread_layer"
  description         = "Provides the Python Requests library and upstream dependencies"
  compatible_runtimes = ["python3.9"]

  source_path = "${path.module}/fixtures/layer"
}

module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "fresh_bread"
  handler       = "fresh_bread.lambda_handler"
  runtime       = "python3.9"
  publish       = true

  source_path = "${path.module}/src/lambda"

  layers = [
    module.lambda_layer_local.lambda_layer_arn,
  ]

  environment_variables = {
    GH_ORG_NAME     = var.gh_org_name
    GH_USER_NAME    = var.gh_user_name
    GH_ACCESS_TOKEN = var.gh_access_token
  }

  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.api_gateway.apigatewayv2_api_execution_arn}/*/*"
    }
  }
}

module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  create_api_gateway               = true
  create_api_domain_name           = false
  create_default_stage             = true
  create_default_stage_api_mapping = true
  create_routes_and_integrations   = true
  create_vpc_link                  = false

  name          = "fresh_bread"
  protocol_type = "HTTP"

  cors_configuration = {
    allow_origins = ["*"]
  }

  default_stage_access_log_destination_arn = aws_cloudwatch_log_group.logs.arn
  default_stage_access_log_format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"

  integrations = {
    "ANY /" = {
      lambda_arn = module.lambda_function.lambda_function_arn
    }
    "ANY /fresh_bread" = {
      lambda_arn = module.lambda_function.lambda_function_arn
    }
    "$default" = {
      lambda_arn = module.lambda_function.lambda_function_arn
    }
  }
}

##### Incidental resources

resource "random_pet" "this" {
  length = 2
}

resource "aws_cloudwatch_log_group" "logs" {
  name = "${random_pet.this.id}-apigateway"
}