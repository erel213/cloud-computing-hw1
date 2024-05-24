provider "aws" {
  region = "eu-west-1" # Ireland
}

module "vpc" {
  source = "./modules/vpc"
}

module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  name = "my-alb"
}

module "iam" {
  source = "./modules/iam"
  dynamodb_arn = module.dynamodb.dynamodb_arn
}

module "dynamodb" {
  source = "./modules/dynamodb"
}