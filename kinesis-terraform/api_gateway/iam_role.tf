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
#######################################################################################################################


resource "aws_iam_role_policy_attachment" "attachment" {
  role       = aws_iam_role.api-kinesis.name
  policy_arn = aws_iam_policy.api-kinesis.arn
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

# curl -XPUT --insecure -u 'admin:admin' 'https://localhost:9200/my-first-index/_doc/1' -H 'Content-Type: application/json' -d '{"Description": "To be or not to be, that is the question."}'
