terraform {
  backend "gcs" {
    bucket = "tfstate-posit-demo"
    prefix = "dev"
    credentials = "./terraform-sa.json"
  }
}
