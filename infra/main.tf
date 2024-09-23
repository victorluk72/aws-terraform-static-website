# 

module "backend" {
  source = "./modules/remote_backend"
  //pass variables to remote-backend module
  iam_user_name       = var.iam_user_name
  backend_bucket_name = var.backend_bucket_name
  state_locking_table = var.state_locking_table
}