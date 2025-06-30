terraform {
  backend "gcs" {
    bucket = "tfstate-posit-demo"
    prefix = "dev"
    # credentials = "C:/KIMBODO/workspace/terraform-gcp-posit/envs/dev/terraform-sa.json"
  }
}
