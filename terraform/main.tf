resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name = "web-instance"
  }
}

resource "aws_lambda_function" "restart_ec2" {
  filename         = "lambda_function.zip"
  function_name    = "restart_ec2_function"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "handler.lambda_handler"
  source_code_hash = filebase64sha256("lambda_function.zip")
  runtime          = "python3.9"

  environment {
    variables = {
      INSTANCE_ID   = aws_instance.web.id
      SNS_TOPIC_ARN = aws_sns_topic.alerts.arn
    }
  }
}

resource "aws_sns_topic" "alerts" {
  name = "alerts_topic"
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
  // Add any additional policies required by the Lambda function
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess", // Ensure you have the necessary policies
    "arn:aws:iam::aws:policy/AmazonSNSFullAccess",
  ]
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:RebootInstances",
          "sns:Publish"
        ]
        Resource = "*"
      }
    ]
  })
}
