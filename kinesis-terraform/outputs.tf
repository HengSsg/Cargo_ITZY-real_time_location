output "stream_arn" {
  value = module.kinesis_data_stream.stream_arn
}
output "aws_elasticsearch_domain_arn" {
  value = module.opensearch_service.aws_elasticsearch_domain_arn
}
output "stream_name" {
  value = module.kinesis_data_stream.stream_name
}
output "domain-name" {
  value = module.opensearch_service.domain-name
}
output "invoke_url" {
  value = "${module.api_gateway.invoke_url}/${module.api_gateway.path_name}"
}
