# Readme

## Quick Note

I used Terraform for Infrastructure as Code (IaC) in this project to practice and improve my knowledge of the technology. I hope it meets your requirements.

## Quick Start

1. Deploy the infrastructure using Terraform.
2. Set up the following secret keys in GitHub Actions:
   - AWS_ACCESS_KEY_ID
   - AWS_ACCOUNT_ID
   - AWS_REGION
   - AWS_SECRET_ACCESS_KEY
   - ECR_REPOSITORY (Use the AWS console management to get the name for the ECR repository)
   
   Note: The IAM user associated with the access key and secret key should have the following policies:

   ### ECR policies

   ```json
   {
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
       "Effect": "Allow",
       "Resource": "*"
   }
   ```

   ### ECS policies

   ```json
   {
       "Version": "2012-10-17",
       "Statement": [
           {
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
               "Effect": "Allow",
               "Resource": "*"
           },
           {
               "Action": [
                   "iam:PassRole"
               ],
               "Effect": "Allow",
               "Resource": "*"
           }
       ]
   }
   ```

3. Run the GitHub Action "deploy-to-ecr" to push the image to ECR and deploy it using ECS Fargate.
4. Use the "ParkingLot.postman_collection.json" to interact with the API.
