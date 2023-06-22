resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "aws-workshop-api-gateway"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "create_short_url_integration" {
  api_id           = aws_apigatewayv2_api.api_gateway.id
  integration_type = "AWS_PROXY"
  //integration_uri  = "${aws_lambda_function.get_long_url.invoke_arn}"
}

resource "aws_apigatewayv2_route" "create_short_url_route" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "POST /shorten"
  target    = "integrations/${aws_apigatewayv2_integration.create_short_url_integration.id}"
}

resource "aws_apigatewayv2_integration" "get_long_url_integration" {
  api_id           = aws_apigatewayv2_api.api_gateway.id
  integration_type = "AWS_PROXY"
  //integration_uri  = aws_lambda_function.get_long_url.invoke_arn
}

resource "aws_apigatewayv2_route" "get_long_url_route" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "GET /{shortId}"
  target    = "integrations/${aws_apigatewayv2_integration.get_long_url_integration.id}"
}
