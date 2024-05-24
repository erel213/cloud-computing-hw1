variable ecs_cluster_name {
    description = "ECS cluster name"
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