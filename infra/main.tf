module "backend" {
  source = "./modules/remote_backend"
  //pass variables to remote_backend module
  iam_user_name       = var.iam_user_name
  backend_bucket_name = var.backend_bucket_name
  state_locking_table = var.state_locking_table
  env                 = var.env_global
}

module "dns_acm" {
  source         = "./modules/route53_acm"
  root_domain    = var.root_domain
  dns_record_ttl = var.dns_record_ttl
}

module "s3_website" {
  source         = "./modules/s3_website"
  website_bucket = var.website_bucket
  #force_destroy      = var.force_destroy
  versioning_enabled = var.versioning_enabled
  index_document     = var.index_document
  region             = var.region_global
  env                = var.env_global
}