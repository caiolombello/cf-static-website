terraform {
  # Mandatory terraform version - 1.3.1 is the last version on 04/10/2022
  required_version = ">=1.3.0"

  # providers - 4.33.0 the last version on 04/10/2022
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.33.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}