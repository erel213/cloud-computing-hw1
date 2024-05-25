output "ecs_task_execution_role_arn" {
    description = "value of the ecs task execution role arn"
    value = aws_iam_role.ecs_task_execution_role.arn
}