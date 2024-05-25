  # ECS Task Execution Role
  resource "aws_iam_role" "ecs_task_execution_role" {
    name               = "ecs-task-execution-role"
    assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
  }

  resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
    role       = aws_iam_role.ecs_task_execution_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  }

  resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_cloudwatch_policy" {
    role       = aws_iam_role.ecs_task_execution_role.name
    policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  }

  # ECS Task Role
  resource "aws_iam_role" "ecs_task_role" {
    name               = "ecs-task-role"
    assume_role_policy = data.aws_iam_policy_document.ecs_task_role.json
  }

  resource "aws_iam_role_policy_attachment" "ecs_task_role_dynamodb_policy" {
    role       = aws_iam_role.ecs_task_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  }

  resource "aws_iam_role_policy_attachment" "ecs_task_role_cloudwatch_policy" {
    role       = aws_iam_role.ecs_task_role.name
    policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  }

  # ECS Task ECR Policy
  resource "aws_iam_policy" "ecs_task_ecr_policy" {
    name        = "ECSTaskECRPolicy"
    description = "Policy to allow ECS tasks to access ECR"
    policy      = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Action = [
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetAuthorizationToken"
          ],
          Resource = "*"
        }
      ]
    })
  }

  resource "aws_iam_role_policy_attachment" "attach_ecr_policy" {
    policy_arn = aws_iam_policy.ecs_task_ecr_policy.arn
    role       = aws_iam_role.ecs_task_execution_role.name
  }


data "aws_iam_policy_document" "ecs_task_execution_role" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_task_role" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
