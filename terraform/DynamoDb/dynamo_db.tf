resource "aws_dynamodb_table" "demo_table" {
  name           = "AWSWorkshopDemoTable"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "PK"
  attribute {
    name = "PK"
    type = "S"
  }
}
