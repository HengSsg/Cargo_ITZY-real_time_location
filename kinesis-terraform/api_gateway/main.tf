# api gateway: rest
resource "aws_api_gateway_rest_api" "rest_api" {
  name = var.name
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}
#########################################################################################

resource "aws_api_gateway_resource" "resource" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = var.path_name_driver
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = var.http_method_driver
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.method.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration" "Integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  type                    = var.integration_type
  integration_http_method = aws_api_gateway_method.method.http_method
  credentials             = aws_iam_role.api-kinesis.arn
  uri                     = "arn:aws:apigateway:${var.region}:kinesis:action/PutRecord"
  timeout_milliseconds    = 29000
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

resource "aws_api_gateway_integration_response" "IntegrationResponse" {
  depends_on = [
    aws_api_gateway_method.method,
    aws_api_gateway_integration.Integration
  ]
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.method.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code
  response_templates = {
    "application/json" = <<EOF
EOF
  }
}


######################################################################################################

resource "aws_api_gateway_resource" "delivery" {
  rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.rest_api.root_resource_id}"
  path_part   = "delivery"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}"
  parent_id   = "${aws_api_gateway_resource.delivery.id}"
  path_part   = "{id}"
}

resource "aws_api_gateway_method" "proxy_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.rest_api.id}"
  resource_id   = "${aws_api_gateway_resource.proxy.id}"
  http_method   = "GET"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.id" = true
  }
}

resource "aws_api_gateway_method_response" "response_200_lambda" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy_method.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration" "Integration-user" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.proxy.id
  http_method             = aws_api_gateway_method.proxy_method.http_method
  type                    = var.integration_type
  integration_http_method = "POST"    //aws_api_gateway_method.method.http_method
  credentials             = aws_iam_role.api-lambda.arn
  uri                     = "arn:aws:apigateway:${var.region}:lambda:action/GetRecord"
  timeout_milliseconds    = 29000
  request_parameters = {
    "integration.request.path.id" = "method.request.path.id"
  }
  request_templates = {
    "application/json" = <<EOF
{"truckerId" : "$input.params('id')"}
EOF
  }
}



resource "aws_api_gateway_integration_response" "IntegrationResponse_user" {
  depends_on = [
    aws_api_gateway_method.proxy_method,
    aws_api_gateway_integration.Integration-user
  ]
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy_method.http_method
  status_code = aws_api_gateway_method_response.response_200_lambda.status_code
  response_templates = {
    "application/json" = <<EOF
EOF
  }
}

################################################################################################################
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name    = var.stage_name

  depends_on = [
    "aws_api_gateway_integration.Integration-user",
    "aws_api_gateway_integration.Integration-userz"
    ] 

}

# resource "aws_api_gateway_stage" "gateway_stage" {
#   deployment_id = aws_api_gateway_deployment.deployment.id
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   stage_name    = var.stage_name
# }