output "stream_arn" {
  value = aws_kinesis_stream.test_stream.arn
}
output "stream_name" {
  value = aws_kinesis_stream.test_stream.name
}