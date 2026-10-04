terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

module "ec2_fleet" {
  source = "./modules/ec2-fleet"

  ami_id      = "ami-0f5ee92e2d63afc18"
  environment = "production"
  owner       = "devops-team"

  instances = {
    "web-server-1" = {
      instance_type = "t3.medium"
      volume_type   = "gp3"
      volume_size   = 30
      key_name      = "web-keypair"
    }
    "web-server-2" = {
      instance_type = "t3.large"
      volume_type   = "gp2"
      volume_size   = 50
      key_name      = "api-keypair"
    }
    "cache-server" = {
      instance_type = "r5.large"
      volume_type   = "io1"
      volume_size   = 100
      key_name      = "cache-keypair"
      iops          = 3000
    }
    "batch-worker" = {
      instance_type = "c5.xlarge"
      volume_type   = "standard"
      volume_size   = 20
      key_name      = "batch-keypair"
    }
    "db-primary-prod" = {
      instance_type = "m5.xlarge"
      volume_type   = "io2"
      volume_size   = 150
      key_name      = "db-keypair"
      iops          = 3000
    }
  }
}

output "instance_ids" {
  value = module.ec2_fleet.instance_ids
}

output "private_ips" {
  value = module.ec2_fleet.private_ips
}
