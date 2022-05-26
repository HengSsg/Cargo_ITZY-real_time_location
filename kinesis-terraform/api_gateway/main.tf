resource "aws_api_gateway_rest_api" "cargo-location" {
  name = var.name
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "location" {
  rest_api_id = aws_api_gateway_rest_api.cargo-location.id
  parent_id   = aws_api_gateway_rest_api.cargo-location.root_resource_id
  path_part   = "location"
}

resource "aws_api_gateway_method" "MyDemoMethod" {
  rest_api_id   = aws_api_gateway_rest_api.cargo-location.id
  resource_id   = aws_api_gateway_resource.location.id
  http_method   = "POST"
  authorization = "NONE"
}


resource "aws_api_gateway_integration" "MyDemoIntegration" {
  rest_api_id          = aws_api_gateway_rest_api.cargo-location.id
  resource_id          = aws_api_gateway_resource.location.id
  http_method          = aws_api_gateway_method.MyDemoMethod.http_method
  type                 = "AWS"
  uri                  = "arn:aws:apigateway:ap-northeast-2:kinesis:PutRecord"
  cache_key_parameters = ["method.request.path.param"]
  cache_namespace      = "foobar"
  timeout_milliseconds = 29000

  request_parameters = {
    "integration.request.header.X-Authorization" = "'static'"
  }

  # Transforms the incoming XML request to JSON
  request_templates = {
    "application/json" = <<EOF
{
    "StreamName": "api-gateway-kinesis-proxy",
    "Data": "$util.base64Encode($input.body)",
    "PartitionKey": "$context.requestId"
}
EOF
  }
}