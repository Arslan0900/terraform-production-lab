terraform {
  backend "s3" {
    bucket       = "arsal-tf-state-406193642614-us-east-1"
    key          = "dev/web-app/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
