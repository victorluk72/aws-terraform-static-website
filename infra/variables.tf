
# global variables---------------------------------------------------
variable "env_global" {
  type        = string
  description = "Environment - dev, uat, prod"
}

variable "region_global" {
  type        = string
  description = "The region in which create/manage resources"
}

variable "aws_profile" {
  type        = string
  description = "AWS account profile details"
}
# -------------------------------------------------------------------

# variables used in "remote_backend" module--------------------------
variable "iam_user_name" {
  type        = string
  description = "AWS IAM user name"
}

variable "backend_bucket_name" {
  type        = string
  description = "S3 bucket name for remote backend"

}
variable "state_locking_table" {
  type        = string
  description = "Dynamo DB table name for remote backend locking"
}
# -------------------------------------------------------------------

# variables used in "route53_acm" module-----------------------------
variable "root_domain" {
  type        = string
  description = "Domain name"
}
variable "dns_record_ttl" {
  type        = number
  description = "Time to live in seconds"
}
# -------------------------------------------------------------------

# variables used in "s3_website" module------------------------------
variable "website_bucket" {
  type        = string
  description = "Name of the S3 bucket to store sttic website"
}
#variable "force_destroy" {}
variable "versioning_enabled" {}
variable "index_document" {}
# -------------------------------------------------------------------
