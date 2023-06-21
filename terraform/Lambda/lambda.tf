resource "aws_lambda_function" "create_short_url" {
  function_name = "createShortURL"
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
  function_name = "getLongURL"
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
