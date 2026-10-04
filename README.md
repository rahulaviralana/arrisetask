# DevOps Infrastructure Engineer III - Assessment

## Structure

```
.
├── modules/
│   └── ec2-fleet/          # Reusable EC2 module (Task 1)
│       ├── versions.tf
│       ├── variables.tf
│       ├── main.tf
│       └── outputs.tf
├── state-bootstrap/        # Bootstraps S3 + DynamoDB for remote state (Task 2)
│   └── main.tf
├── account-a/              # IAM users, groups, roles in Account A (Task 3)
│   └── iam.tf
├── account-b/              # Cross-account IAM role in Account B (Task 3)
│   └── iam.tf
├── main.tf                 # Root config - calls ec2-fleet module with 5 instances
├── backend.tf              # S3 remote state backend config (Task 2)
├── ci-policy.json          # Least-privilege IAM policy for CI user (Task 4)
└── DEVOPS_ASSIGNMENT_SOLUTION.txt  # Full written answers including Task 5 bug analysis
```

## Tasks

**Task 1** - Terraform module (`modules/ec2-fleet`) that provisions 5 EC2 instances using `for_each` over a single `map(object(...))` input variable. All instances have `prevent_destroy = true` in their lifecycle block.

**Task 2** - S3 backend with DynamoDB state locking. `state-bootstrap/` provisions the bucket and table first, then `backend.tf` activates the backend via `terraform init -migrate-state`.

**Task 3** - Multi-account IAM setup. Account A has 4 users, 2 groups, and 2 roles. Account B has roleC with a trust policy scoped to the specific ARN of roleB (not account root) and full S3 access scoped to a single bucket.

**Task 4** - Least-privilege policy for the CI user covering ECR push, ECS deploy, `iam:PassRole` (scoped to ECS with a service condition), and S3 artifact read-only.

**Task 5** - Two bugs in the provided Terraform snippet. See `DEVOPS_ASSIGNMENT_SOLUTION.txt` for the full analysis and fixes.
