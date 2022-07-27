#create s3 backend for tfstate
module "tfstate_s3_backend" {
  source               = "./s3-backend"
  name_of_s3_bucket    = var.tfstate_s3_bucket_name
  dynamo_db_table_name = var.tfstate_dynamo_db_table_name
  s3_bucket_region     = var.tfstate_s3_bucket_region
}

#create IAM user for azuredevops connection
module "iam_user_for_azuredevops" {
  source              = "./iam-for-azuredevops"
  s3_bucket_arn       = module.tfstate_s3_backend.s3_bucket_arn
  iam_user_name       = var.iam_user_name
  aws_iam_policy_name = var.aws_iam_policy_name
}

resource "local_file" "s3_backend" {
  content  = <<EOT
    terraform {

      backend "s3" {
        bucket         = "${var.tfstate_s3_bucket_name}"
        region         = "${var.tfstate_s3_bucket_region}"
        key            = "${var.tfstate_filename}"
        dynamodb_table = "${var.tfstate_dynamo_db_table_name}"
      }
    }
    EOT
  filename = "${path.module}/use-for-tfstate/backend.tf"
}