output "invoke_url" {
  value = aws_api_gateway_stage.gateway_stage.invoke_url
}
output "path_name" {
  value = aws_api_gateway_resource.resource.path_part
}