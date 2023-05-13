# definicao do provider como aws
provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias  = "ACM"
  region = "us-east-1"
}

terraform {

  # versao minima obrigatoria do terraform
  required_version = ">= 1.4"

  # providers obrigatorios
  required_providers {

    aws = {

      source  = "hashicorp/aws"
      version = "4.67.0"

    }

    archive = {
      source = "hashicorp/archive"
    }

  }
}