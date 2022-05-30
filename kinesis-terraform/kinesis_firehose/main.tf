resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

resource "aws_kinesis_firehose_delivery_stream" "firehose" {
  name        = var.name
  destination = var.destination

  kinesis_source_configuration {
    kinesis_stream_arn = var.stream_arn
    role_arn           = aws_iam_role.firehose_role.arn
  }

  elasticsearch_configuration {
    domain_arn            = var.domain_arn
    index_name            = var.es_index_name
    index_rotation_period = "NoRotation"
    type_name             = ""
    role_arn              = aws_iam_role.firehose_role.arn
    buffering_interval    = 60
    buffering_size        = 1
    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/${var.name}"
      log_stream_name = var.log_stream_name
    }
  }
  s3_configuration {
    role_arn           = aws_iam_role.firehose_role.arn
    bucket_arn         = aws_s3_bucket.bucket.arn
    buffer_size        = 1
    buffer_interval    = 60
    compression_format = "GZIP"
  }

}




resource "aws_iam_role" "firehose_role" {
  name = "kinesis-firehose_role"

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

resource "aws_iam_policy" "firehose-policy" {
  name        = "firehose-kinesis-es-policy"
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
  policy_arn = aws_iam_policy.firehose-policy.arn
}
