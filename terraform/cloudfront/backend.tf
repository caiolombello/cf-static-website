# remote backend -- Is necessary create to bucket previous 
terraform {
  backend "s3" {
    bucket         = "caio.lombello.com-prd"
    key            = "caio.lombello.com-prd/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "caio.lombello.com-prd-tfstate"
  }
}