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
  required_version = ">= 1.0.19"

  # providers obrigatorios
  required_providers {

    aws = {

      source  = "hashicorp/aws"
      version = "3.32.0"

    }

  }
}