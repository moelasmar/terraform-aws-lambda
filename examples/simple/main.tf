provider "aws" {
  region = "us-west-1"
}

module "lambda_layer_local" {
  source = "../../"

  create_layer = true

  layer_name               = "${random_pet.this.id}-layer-local"
  description              = "My amazing lambda layer (deployed from local)"
  compatible_runtimes      = ["python3.8"]
  runtime                  = "python3.8"

  source_path = {
    path = "${path.module}/fixtures/python3.8-layer"
    prefix_in_zip = "python"
    pip_requirements = true
  }
}

module "lambda_function" {
  source = "../../"

  publish = true

  function_name = "${random_pet.this.id}-lambda-simple"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  layers = [
    module.lambda_layer_local.lambda_layer_arn,
  ]

  source_path = "${path.module}/fixtures/python3.8-app1/"
}

module "lambda_function_2" {
  source = "../../"

  publish = true

  function_name = "${random_pet.this.id}-lambda-simple-2"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  layers = [
    module.lambda_layer_local.lambda_layer_arn,
  ]

  source_path = "${path.module}/fixtures/python3.8-app2/"
}


resource "random_pet" "this" {
  length = 2
}

output "lambda_function_arn" {
  description = "The ARN of the Lambda Function"
  value       = module.lambda_function.lambda_function_arn
}

output "lambda_function_name" {
  description = "The name of the Lambda Function"
  value       = module.lambda_function.lambda_function_name
}

output "lambda_function_2_arn" {
  description = "The ARN of the Lambda Function 2"
  value       = module.lambda_function_2.lambda_function_arn
}

output "lambda_function_2_name" {
  description = "The name of the Lambda Function 2"
  value       = module.lambda_function_2.lambda_function_name
}