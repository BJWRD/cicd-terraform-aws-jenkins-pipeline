terraform {
  backend "s3" {
    bucket = "cicd-terraform-aws-jenkins-pipeline"
    key    = "terraform.tfstate"
    region = "eu-west-2"
  }
}