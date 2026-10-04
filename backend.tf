terraform {
  backend "s3" {
    bucket         = "my-company-terraform-state"
    key            = "ec2-fleet/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
