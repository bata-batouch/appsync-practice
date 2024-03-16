terraform {
  required_version = ">= 1.5.7"
  backend "s3" {
    bucket  = "sci01927-kawabata-sandbox-tfstate"
    region  = "ap-northeast-1"
    key     = "appsync-practice.tfstate"
    encrypt = true
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
provider "aws" {
  region = "ap-northeast-1"
}