provider "aws" {
  region = "ap-south-1"
}

resource "aws_iam_user" "engine" { name = "engine" }
resource "aws_iam_user" "ci"     { name = "ci"     }
resource "aws_iam_user" "alice"  { name = "alice"  }
resource "aws_iam_user" "bob"    { name = "bob"    }

resource "aws_iam_group" "group1" { name = "group1" }

resource "aws_iam_group_policy" "group1_deny_console" {
  name  = "deny-console-access"
  group = aws_iam_group.group1.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyConsoleLogin"
        Effect = "Deny"
        Action = [
          "iam:CreateLoginProfile",
          "iam:UpdateLoginProfile",
          "iam:DeleteLoginProfile",
          "iam:GetLoginProfile"
        ]
        Resource = "arn:aws:iam::000000000000:user/*"
      }
    ]
  })
}

resource "aws_iam_group_membership" "group1" {
  name  = "group1-membership"
  group = aws_iam_group.group1.name
  users = [aws_iam_user.engine.name, aws_iam_user.ci.name]
}

resource "aws_iam_group" "group2" { name = "group2" }

resource "aws_iam_group_policy_attachment" "group2_admin" {
  group      = aws_iam_group.group2.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_group_membership" "group2" {
  name  = "group2-membership"
  group = aws_iam_group.group2.name
  users = [aws_iam_user.alice.name, aws_iam_user.bob.name]
}

resource "aws_iam_role" "roleA" {
  name = "roleA"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { AWS = "arn:aws:iam::000000000000:root" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "roleA_policy" {
  name = "admin-except-iam"
  role = aws_iam_role.roleA.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowEverything"
        Effect   = "Allow"
        Action   = "*"
        Resource = "*"
      },
      {
        Sid      = "DenyIAM"
        Effect   = "Deny"
        Action   = "iam:*"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "roleB" {
  name = "roleB"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { AWS = "arn:aws:iam::000000000000:root" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "roleB_assume_roleC" {
  name = "assume-roleC-only"
  role = aws_iam_role.roleB.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "sts:AssumeRole"
      Resource = "arn:aws:iam::111111111111:role/roleC"
    }]
  })
}
