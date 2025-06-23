# IAM Role for Lambda
resource "aws_iam_role" "lambda" {
  name        = "LambdaRole"
  description = "Allows Lambda functions to call AWS services on your behalf."

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach policy
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Zip lambda function
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/lambda_function.zip"
}

# Deploy
resource "aws_lambda_function" "python_area" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "python_area"
  role             = aws_iam_role.lambda.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.13"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  tags = {
    Environment = "production"
    Application = "python_area_calculator"
    deployed-by = var.deployed_by
  }
}

# Zip second lambda function
data "archive_file" "lambda_zip_2" {
  type        = "zip"
  source_file = "${path.module}/lambda_function_2.py"
  output_path = "${path.module}/lambda_function_2.zip"
}

# Deploy second lambda
resource "aws_lambda_function" "python_area_2" {
  filename         = data.archive_file.lambda_zip_2.output_path
  function_name    = "python_area_2"
  role             = aws_iam_role.lambda.arn
  handler          = "lambda_function_2.lambda_handler"
  runtime          = "python3.13"
  source_code_hash = data.archive_file.lambda_zip_2.output_base64sha256

  tags = {
    Environment = "production"
    Application = "python_area_calculator_v2"
    deployed-by = var.deployed_by
  }
}