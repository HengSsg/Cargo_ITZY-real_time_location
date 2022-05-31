resource "aws_kinesis_stream" "Data_stream" {
  name             = var.name
  shard_count      = 1
  retention_period = 24

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }
}
