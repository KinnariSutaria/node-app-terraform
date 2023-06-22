resource "aws_lambda_function" "create_short_url" {
  function_name = "create_short_url"

  # "main" is the filename within the zip file (main.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  runtime       = "nodejs14.x"
  handler       = "index.handler"
  filename      = "createShortURL.js.zip"
  role = aws_iam_role.lambdaRole.arn
  layers = [aws_lambda_layer_version.node_layer.arn]
}

resource "aws_lambda_function" "get_long_url" {
  function_name = "get_long_url"

  # "main" is the filename within the zip file (main.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  runtime       = "nodejs14.x"
  handler       = "index.handler"
  filename      = "getLongURL.js.zip"
  role = aws_iam_role.lambdaRole.arn
  layers = [aws_lambda_layer_version.node_layer.arn]
}


resource "aws_lambda_layer_version" "node_layer" {
  filename   = "lambdalayer.zip"
  layer_name = "node_layer"
  compatible_runtimes = ["nodejs14.x"]

}

# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "lambdaRole" {
  name = "LambdaRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda-policy-attachment" {
  role       = aws_iam_role.lambdaRole.name
  policy_arn = aws_iam_policy.dynamoDBLambdaPolicy.arn
}

resource "aws_iam_policy" "cloudWatchLambdaPolicy" {
  name = "cloudWatchLambdaPolicy"

  policy = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "autoscaling:Describe*",
            "cloudwatch:*",
            "logs:*",
            "sns:*",
            "iam:GetPolicy",
            "iam:GetPolicyVersion",
            "iam:GetRole",
            "oam:ListSinks"
          ],
          "Resource": "*"
        },
        {
          "Effect": "Allow",
          "Action": "iam:CreateServiceLinkedRole",
          "Resource": "arn:aws:iam::*:role/aws-service-role/events.amazonaws.com/AWSServiceRoleForCloudWatchEvents*",
          "Condition": {
            "StringLike": {
              "iam:AWSServiceName": "events.amazonaws.com"
            }
          }
        },
        {
          "Effect": "Allow",
          "Action": [
            "oam:ListAttachedLinks"
          ],
          "Resource": "arn:aws:oam:*:*:sink/*"
        }
      ]
    }

  )
}

resource "aws_iam_role_policy_attachment" "cloudwatch-policy-attachment" {
  role       = aws_iam_role.lambdaRole.name
  policy_arn = aws_iam_policy.cloudWatchLambdaPolicy.arn
}