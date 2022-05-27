resource "aws_api_gateway_rest_api" "cargo-location" {
  name = var.name
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "location" {
  rest_api_id = aws_api_gateway_rest_api.cargo-location.id
  parent_id   = aws_api_gateway_rest_api.cargo-location.root_resource_id
  path_part   = var.path_name
}

resource "aws_api_gateway_method" "MyDemoMethod" {
  rest_api_id   = aws_api_gateway_rest_api.cargo-location.id
  resource_id   = aws_api_gateway_resource.location.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.cargo-location.id
  resource_id = aws_api_gateway_resource.location.id
  http_method = aws_api_gateway_method.MyDemoMethod.http_method
  status_code = "200"
  # response_parameters = { "method.response.body.application/json" = true } 

}

resource "aws_api_gateway_integration" "MyDemoIntegration" {
  rest_api_id          = aws_api_gateway_rest_api.cargo-location.id
  resource_id          = aws_api_gateway_resource.location.id
  http_method          = aws_api_gateway_method.MyDemoMethod.http_method
  type                 = var.integration_type
  integration_http_method = aws_api_gateway_method.MyDemoMethod.http_method
  credentials = aws_iam_role.api-kinesis.arn
  uri                  = "arn:aws:apigateway:${var.region}:kinesis:action/PutRecord"
  # cache_key_parameters = ["method.request.path.param"]
  # cache_namespace      = "foobar"
  timeout_milliseconds = 29000

  # request_parameters = {
  #   "integration.request.header.X-Authorization" = "'static'"
  # }

  # Transforms the incoming XML request to JSON
  request_templates = {
    "application/json" = <<EOF
{
    "StreamName": "${var.stream_name}",
    "Data": "$util.base64Encode($input.body)",
    "PartitionKey": "$context.requestId"
}
EOF
  }
}

resource "aws_api_gateway_integration_response" "MyDemoIntegrationResponse" {
  rest_api_id = aws_api_gateway_rest_api.cargo-location.id
  resource_id = aws_api_gateway_resource.location.id
  http_method = aws_api_gateway_method.MyDemoMethod.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code

  # Transforms the backend JSON response to XML
  response_templates = {
    "application/xml" = <<EOF
#set($inputRoot = $input.path('$'))
<?xml version="1.0" encoding="UTF-8"?>
<message>
    $inputRoot.body
</message>
EOF
  }
}

resource "aws_iam_role" "api-kinesis" {
  name = "api-kinesis"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "apigateway.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "api-kinesis" {
  name        = "api-kinesis-policy"
  description = "A test policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "kinesis:PutRecord"
            ],
            "Resource": [
                "arn:aws:kinesis:${var.region}:${var.account}:stream/${var.stream_name}"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.api-kinesis.name
  policy_arn = aws_iam_policy.api-kinesis.arn
}