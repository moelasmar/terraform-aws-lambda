terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.19"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.0"
    }
  }
  
  backend "s3" {
    # Update the remote backend below to support your environment
    bucket         = "melasmar-sample-tf-state-us-west-1"
    key            = "sample/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "sample-terraform-state"
    encrypt        = true
  }
  
}
