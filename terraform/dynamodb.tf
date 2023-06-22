resource "aws_dynamodb_table" "AWSWorkshopDemoTable" {
  name           = "AWSWorkshopDemoTable"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "PK"
  attribute {
    name = "PK"
    type = "S"
  }
}

resource "aws_iam_policy" "dynamoDBLambdaPolicy" {
  name = "DynamoDBLambdaPolicy"

  policy = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "dynamodb:*"
          ],
          "Resource": [
            "arn:aws:dynamodb:*:*:table/*"
          ]
        }
      ]
    }


  )
}

