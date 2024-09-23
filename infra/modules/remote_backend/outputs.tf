# share details about resourse created in the module
output "iam_user_arn" {
  value = aws_iam_user.terraform_user.arn
}