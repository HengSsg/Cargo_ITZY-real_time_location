### iam role ###
resource "aws_iam_role" "api_kinesis_put_record" {
  name = "api_kinesis_put_record"

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

resource "aws_iam_policy" "api_kinesis_put_record" {
  name        = "api_kinesis_put_recordpolicy"
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
  role       = aws_iam_role.api_kinesis_put_record.name
  policy_arn = aws_iam_policy.api_kinesis_put_record.arn
}

#######################################################################################################################

resource "aws_iam_role" "api_lambda_role" {
  name = "api_lambda_role"

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

resource "aws_iam_policy" "api_lambda_policy" {
  name = "api_lambda_policy"

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
  role       = aws_iam_role.api_lambda_role.name
  policy_arn = aws_iam_policy.api_lambda_policy.arn
}