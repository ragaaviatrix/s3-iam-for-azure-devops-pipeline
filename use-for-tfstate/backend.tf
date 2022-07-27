terraform {

  backend "s3" {
    bucket         = "azuredevops27072022"
    region         = "eu-west-1"
    key            = "avxstate.tfstate"
    dynamodb_table = "terraformlocktable"
  }
}
