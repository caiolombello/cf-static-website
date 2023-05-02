# remote backend -- Is necessary create to bucket previous 
terraform {
  backend "s3" {
    bucket         = "portfolio-prd"
    key            = "portfolio-prd/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "portfolio-prd-tfstate"
  }
}