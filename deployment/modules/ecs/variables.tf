variable ecs_cluster_name {
    description = "ECS cluster name"
    type = string
}

variable "vpc_id" {
    description = "value of the vpc id"
    type = string
}

variable "task_definition_name" {
    description = "ECS task definition name"
    type = string
}


variable "fargate_cpu" {
    description = "value of cpu for task"
    type = number
}

variable "fargate_memory" {
    description = "value of memory for task"
    type = number
}

variable "service_name" {
    type = string
}

variable "desired_task_count" {
    description = "the amount of tasks to run"
    type = number
}

variable "private_subnet_ids" {
    description = "list of private subnet ids"
    type = list(string)
}

variable "container_name" {
  description = "container name"
  type = string
}

variable "container_port" {
  description = "value of port for container"
  type = number
}

variable "target_group_arn" {
  description = "target group arn"
  type = string
}

variable "alb_security_group_Id"{
  description = "security group id for alb"
  type = string
}

variable "ecs_task_execution_role_arn" {
  description = "value of the ecs task execution role arn"
  type = string
}

variable "ecs_task_role_arn" {
  description = "value of the ecs task role arn"
  type = string
}

variable "aws_region" {
  description = "aws region"
  type = string
}

variable "cloudwatch_log_group_name" {
  description = "cloudwatch log group name"
  type = string
}