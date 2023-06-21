provider "aws" {
  region = "us-east-1"
}

module "dynamodb" {
  source   = "./dynamodb"
  table_name = "AWSWorkshopDemoTable"
}

module "lambda_create_short_url" {
  source  = "./lambda"
  function_name = "createShortURL"
  runtime = "nodejs14.x"
  execution_role = "aws-workshop-lambda-role"
}

module "lambda_get_long_url" {
  source  = "./lambda"
  function_name = "getLongURL"
  runtime = "nodejs14.x"
  execution_role = "aws-workshop-lambda-role"
}

module "api_gateway" {
  source = "./api_gateway"
  api_name = "aws-workshop-api-gateway"
  lambda_create_short_url = module.lambda_create_short_url.function_name
  lambda_get_long_url = module.lambda_get_long_url.function_name
}
