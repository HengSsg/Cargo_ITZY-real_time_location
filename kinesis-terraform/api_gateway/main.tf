# api gateway: rest
resource "aws_api_gateway_rest_api" "rest_api" {
  name = var.name
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}
####
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

### iam role ###
resource "aws_iam_role" "api-kinesis" {
  name = "api-kinesis-role"

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

resource "aws_iam_role_policy_attachment" "attachment" {
  role       = aws_iam_role.api-kinesis.name
  policy_arn = aws_iam_policy.api-kinesis.arn
}

###################################VVV-API-GATEWAY-LAMBDA-AREA-VVV#################################################

# resource "aws_api_gateway_resource" "driver" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
#   path_part   = var.path_name_user
# }

# resource "aws_api_gateway_resource" "resource_user" {
#   path_part   = "{id}"
#   parent_id   = aws_api_gateway_resource.driver.id  
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
# }

# resource "aws_api_gateway_method" "method_user" {
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   resource_id   = aws_api_gateway_resource.resource_user.id
#   http_method   = "GET" 
#   authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "integration" {
#   rest_api_id             = aws_api_gateway_rest_api.rest_api.id
#   resource_id             = aws_api_gateway_resource.resource_user.id
#   http_method             = aws_api_gateway_method.method_user.http_method
#   integration_http_method = "POST"
#   type                    = "AWS_PROXY"
#   uri                     = var.lambda_invoke_arn
# }
################################################################################################################
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

resource "aws_iam_role" "api-lambda" {
  name = "api-lambda"

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

resource "aws_iam_policy" "api-lambda" {
  name        = "api-lambda-policy"


  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:lambda:ap-northeast-2:${var.account}:function:${var.function_name}"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attachment_lambda" {
  role       = aws_iam_role.api-lambda.name
  policy_arn = aws_iam_policy.api-lambda.arn
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
    aws_api_gateway_method.method,
    aws_api_gateway_method.proxy_method
    ] 

}

# resource "aws_api_gateway_stage" "gateway_stage" {
#   deployment_id = aws_api_gateway_deployment.deployment.id
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   stage_name    = var.stage_name
# }