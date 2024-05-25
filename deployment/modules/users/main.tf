resource "aws_iam_user" "ci_cd_user" {
  name = "ci-cd-user"
}

resource "aws_iam_user_policy" "ci_cd_ecr_policy" {
  name   = "ci-cd-ecr-policy"
  user   = aws_iam_user.ci_cd_user.name
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:GetAuthorizationToken",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:DescribeRepositories",
          "ecr:GetRepositoryPolicy",
          "ecr:ListImages",
          "ecr:DeleteRepository",
          "ecr:BatchDeleteImage",
          "ecr:SetRepositoryPolicy",
          "ecr:DeleteRepositoryPolicy",
          "ecr:DescribeImages",
          "ecr:ListTagsForResource",
          "ecr:UntagResource",
          "ecr:TagResource",
          "ecr:CreateRepository"
        ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_user_policy" "ci_cd_ecs_policy" {
  name   = "ci-cd-ecs-policy"
  user   = aws_iam_user.ci_cd_user.name
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ecs:UpdateService",
          "ecs:DescribeServices",
          "ecs:ListServices",
          "ecs:DescribeTaskDefinition",
          "ecs:DescribeTasks",
          "ecs:ListTasks",
          "ecs:UpdateTaskSet",
          "ecs:CreateTaskSet",
          "ecs:DeleteTaskSet",
          "ecs:TagResource"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "iam:PassRole"
        ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_access_key" "ci_cd_access_key" {
  user = aws_iam_user.ci_cd_user.name
}
