terraform {
  backend "s3" {
    bucket         = "tfstate-posit-demo-aws"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tfstate-locks"
  }
}
