output "aws_elasticsearch_domain_arn" {
  value = aws_elasticsearch_domain.cargoitzy.arn
}
output "domain-name" {
  value = aws_elasticsearch_domain.cargoitzy.domain_name
}
output "es_endpoint" {
  value = aws_elasticsearch_domain.cargoitzy.endpoint
}