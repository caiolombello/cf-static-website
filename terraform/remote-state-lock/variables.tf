variable "aws_region" {

  type        = string
  description = ""
  default     = "us-east-1"

}

variable "resource_tags" {
  description = "Tags to set for all resources"
  type        = map(string)
  default = {
    Environment = "prd",
    Terraform   = "true"
    Name        = "caio.lombello.com"
  }
}
