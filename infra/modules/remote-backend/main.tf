# define IAM User for Terraform
resource "aws_iam_user" "terraform_user" {
  name = var.iam_user_name
}

# Attach AdministratorAccess policy to the IAM user (see IM user above)
resource "aws_iam_user_policy_attachment" "admin_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  user       = aws_iam_user.terraform_user.id
}

# S3 Bucket for Terraform state
resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = var.backend_bucket_name

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = var.backend_bucket_name
    Environment = "Dev - To Be Changed to variable" //TBD
  }
}

# Enable versioning for the S3 bucket  (allow to recover previouse version of bucket)
resource "aws_s3_bucket_versioning" "versioning_enabled" {
  bucket = aws_s3_bucket.terraform_state_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket Policy (manages access to S3 bucket/list/read/write)
resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.terraform_state_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "s3:ListBucket", //allow user see all objects in the bucket
        Resource = aws_s3_bucket.terraform_state_bucket.arn,
        Principal = {
          AWS = aws_iam_user.terraform_user.arn // user to whom this statement applies
        }
      },
      {
        Effect   = "Allow",
        Action   = ["s3:GetObject", "s3:PutObject"],                // this allow user to read and write to terraform bucket
        Resource = "${aws_s3_bucket.terraform_state_bucket.arn}/*", //(/* means that permitions applies to all objects in the S3 bucket)
        Principal = {
          AWS = aws_iam_user.terraform_user.arn // user to whom this statement applies
        }
      }
    ]
  })
}

# DynamoDB Table for state locking
resource "aws_dynamodb_table" "state_lock_table" {
  name         = var.state_locking_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = var.state_locking_table
    Environment = "Dev - To Be Changed to variable" //TBD
  }
}