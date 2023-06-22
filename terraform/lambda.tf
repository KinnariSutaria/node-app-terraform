resource "aws_lambda_function" "create_short_url" {
  function_name = "create_short_url"

  # "main" is the filename within the zip file (main.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  runtime       = "nodejs14.x"
  handler       = "index.handler"
  filename      = "../createShortURL.js.zip"
  role = aws_iam_role.lambda_exec.arn
  layers = [aws_lambda_layer_version.node_layer.arn]
}

resource "aws_lambda_function" "get_long_url" {
  function_name = "get_long_url"

  # "main" is the filename within the zip file (main.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  runtime       = "nodejs14.x"
  handler       = "index.handler"
  filename      = "../getLongURL.js.zip"
  role = aws_iam_role.lambda_exec.arn
  layers = [aws_lambda_layer_version.node_layer.arn]
}


resource "aws_lambda_layer_version" "node_layer" {
  filename   = "../lambdalayer.zip"
  layer_name = "node_layer"
  compatible_runtimes = ["nodejs14.x"]

}

# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "lambda_exec" {
  name = "serverless_example_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}