resource "aws_s3_bucket" "bucket" {
  bucket = "tf-test-bucket-cargo-buc"
}

resource "aws_kinesis_firehose_delivery_stream" "test_stream" {
  name        = "terraform-kinesis-firehose-test-stream"
  destination = "elasticsearch"

  kinesis_source_configuration {
    kinesis_stream_arn = var.stream_arn
    role_arn           = aws_iam_role.firehose_role.arn
  }

  elasticsearch_configuration {
    domain_arn = var.domain_arn
    index_name = "test"
    type_name  = ""
    role_arn   = aws_iam_role.firehose_role.arn
    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = var.log_group_name
      log_stream_name = "example"
    }
  }
  s3_configuration {
    role_arn           = aws_iam_role.firehose_role.arn
    bucket_arn         = aws_s3_bucket.bucket.arn
    buffer_size        = 10
    buffer_interval    = 400
    compression_format = "GZIP"
  }

}


resource "aws_iam_role" "firehose_role" {
  name = "firehose_role-1"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole"
      ],
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
    
  ]
}
EOF
}

resource "aws_iam_policy" "policy" {
  name        = "test-policy"
  description = "A test policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "kinesis:*",
              "firehose:*",
              "es:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.firehose_role.name
  policy_arn = aws_iam_policy.policy.arn
}
