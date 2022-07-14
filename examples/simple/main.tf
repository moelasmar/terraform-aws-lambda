provider "aws" {
  region = "us-west-1"
}

resource "aws_s3_bucket" "books_input_bucket" {
  bucket = "${random_pet.this.id}-books-input"
}
resource "aws_s3_object" "books_input" {
  bucket = aws_s3_bucket.books_input_bucket.bucket
  key    = "books_input"
  source = "books_input.csv"
}

module "languages_lib_layer" {
  source = "../../"

  create_layer = true

  layer_name               = "${random_pet.this.id}-layer-local"
  description              = "My amazing lambda layer (deployed from local)"
  compatible_runtimes      = ["python3.8"]
  runtime                  = "python3.8"

  source_path = {
    path = "${path.module}/fixtures/languages_lib"
    prefix_in_zip = "python"
    pip_requirements = true
  }
}

module "get_country_languages" {
  source = "../../"

  publish = true

  function_name = "${random_pet.this.id}_get_country_languages"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  layers = [
    module.languages_lib_layer.lambda_layer_arn,
  ]

  source_path = "${path.module}/fixtures/get_country_languages/"
}

module "load_books" {
  source = "../../"

  publish = true

  function_name = "${random_pet.this.id}-load-books"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  layers = [
    module.languages_lib_layer.lambda_layer_arn,
  ]
  environment_variables = {
    books_table_id = module.books_dynamodb_table.dynamodb_table_id,
    books_input_bucket = aws_s3_bucket.books_input_bucket.bucket,
    books_input = aws_s3_object.books_input.key
  }
  timeout = 10
  source_path = "${path.module}/fixtures/load_books/"

  policy_statements = {
    s3_all = {
      effect    = "Allow",
      actions   = ["s3:*"],
      resources = ["*"]
    },
    
    dynamodb_all = {
      effect    = "Allow",
      actions   = ["dynamodb:*"],
      resources = ["*"]
    }
  }

  attach_policy_statements = true
}

module "list_books" {
  source = "../../"

  publish = true

  function_name = "${random_pet.this.id}-list-books"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"
  environment_variables = {
    books_table_id = module.books_dynamodb_table.dynamodb_table_id
  }
  timeout = 10
  source_path = "${path.module}/fixtures/list_books/"
  policy_statements = {
    dynamodb_all = {
      effect    = "Allow",
      actions   = ["dynamodb:scan"],
      resources = ["*"]
    }
  }
  attach_policy_statements = true
}

module "books_dynamodb_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"

  name     = "books-table"
  hash_key = "id"

  attributes = [
    {
      name = "id",
      type = "S"
    },
    {
      name = "title",
      type = "S"
    },
    {
      name = "language",
      type = "S"
    }
  ]

  global_secondary_indexes = [
    {
      name               = "BookTitle"
      hash_key           = "title"
      projection_type    = "INCLUDE"
      non_key_attributes = ["id"]
    },
    {
      name               = "BookLanguage"
      hash_key           = "language"
      projection_type    = "INCLUDE"
      non_key_attributes = ["id"]
    }
  ]

}



resource "random_pet" "this" {
  length = 2
}

output "load_books_function_arn" {
  description = "The ARN of the Lambda Function"
  value       = module.load_books.lambda_function_arn
}

output "load_books_function_name" {
  description = "The name of the Lambda Function"
  value       = module.load_books.lambda_function_name
}

output "list_books_function_arn" {
  description = "The ARN of the list_books"
  value       = module.list_books.lambda_function_arn
}

output "list_books_function_name" {
  description = "The name of the Lambda Function 2"
  value       = module.list_books.lambda_function_name
}

output "books_input_bucket" {
  description = "The name of the books input bucket"
  value = aws_s3_bucket.books_input_bucket.bucket
}