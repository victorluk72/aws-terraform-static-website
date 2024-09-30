resource "aws_s3_bucket" "website_bucket" {
  bucket = "${var.website_bucket}-${var.env}"
  #force_destroy = var.force_destroy  
  force_destroy = var.env == "dev" ? "true" : "false" //true for dev, false for prod

  tags = {
    Name = "Website bucket for ${var.website_bucket}-${var.env}"
  }
}

resource "aws_s3_bucket_versioning" "website_versioning" {
  bucket = aws_s3_bucket.website_bucket.id

  versioning_configuration {
    status = var.versioning_enabled
  }
}

# IMPORTANT: This configure s3 bucket as a storage for static website
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = var.index_document
  }
}

resource "aws_s3_bucket_public_access_block" "website_bucket_allow_public_access" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# allow "read" access to the S3 bucket and all folders in the bucket
resource "aws_s3_bucket_policy" "website_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = ["s3:GetObject"],
        Effect    = "Allow",
        Resource  = ["${aws_s3_bucket.website_bucket.arn}/*"],
        Principal = "*"
      },
    ]
  })
  depends_on = [aws_s3_bucket_public_access_block.website_bucket_allow_public_access]
}