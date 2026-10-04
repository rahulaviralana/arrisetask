provider "aws" {
  region = "ap-south-1"
}

resource "aws_iam_role" "roleC" {
  name = "roleC"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { AWS = "arn:aws:iam::000000000000:role/roleB" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "roleC_s3" {
  name = "roleC-s3-full-access-single-bucket"
  role = aws_iam_role.roleC.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "s3:*"
      Resource = [
        "arn:aws:s3:::cross-account-data-bucket",
        "arn:aws:s3:::cross-account-data-bucket/*"
      ]
    }]
  })
}
