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

module "cloudwatch" {
  source = "./modules/cloudwatch"
}

module "ecs" {
  source = "./modules/ecs"
  ecs_cluster_name = "parking_lot_cluster"
  task_definition_name = "parking_lot_task"
  fargate_cpu = 256
  fargate_memory = 512
  service_name = "parking_lot_service"
  desired_task_count = 1
  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  private_subnet_ids = module.vpc.private_subnet_ids
  container_name = "parking_lot_container"
  container_port = 80
  alb_security_group_Id = module.alb.alb_security_group_id
  vpc_id = module.vpc.vpc_id
  target_group_arn = module.alb.target_group_arn
  aws_region = "eu-west-1"
  cloudwatch_log_group_name = module.cloudwatch.ecs_task_definition_log_group_name
}

module "users" {
  source = "./modules/users"
}