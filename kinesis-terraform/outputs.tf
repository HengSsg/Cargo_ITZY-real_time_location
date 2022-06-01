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
output "domain-endpoint" {
  value       = module.opensearch_service.domain-endpoint
  description = "람다 환경변수"
}
output "lambda_function_" {
  value = module.lambda_function.lambda_function_
}
output "lambda_function_name" {
  value = module.lambda_function.lambda_function_name
}