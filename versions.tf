terraform {
  required_version = ">= 0.13.1"

  required_providers {
<<<<<<< HEAD
    aws      = ">= 3.61"
    external = ">= 1"
    local    = ">= 1"
    null     = ">= 2"
    sammetadata = {
      version = ">= 3"
      source  = "amazon.com/aws/sammetadata"
=======
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.9"
    }
    external = {
      source  = "hashicorp/external"
      version = ">= 1.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 1.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 2.0"
>>>>>>> e7bfddf314bf915bfb4b2d58b6740f1d6c376be3
    }
  }
}
