resource "aws_lambda_function" "create_short_url" {
  function_name = "create_short_url"
  runtime       = "nodejs14.x"
  handler       = "index.handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/createShortURL.zip"
  source_code_hash = filebase64sha256("${path.module}/createShortURL.zip")

  environment {
    variables = {
      # Add any environment variables if required
    }
  }
}

resource "aws_lambda_function" "get_long_url" {
  function_name = "get_long_url"
  runtime       = "nodejs14.x"
  handler       = "index.handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/getLongURL.zip"
  source_code_hash = filebase64sha256("${path.module}/getLongURL.zip")

  environment {
    variables = {
      # Add any environment variables if required
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "aws-workshop-lambda-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

