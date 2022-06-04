output "invoke_url" {
  value = aws_api_gateway_deployment.deployment.invoke_url
}

output "path_name" {
  value = aws_api_gateway_resource.kinesis_put_record.path_part
}

