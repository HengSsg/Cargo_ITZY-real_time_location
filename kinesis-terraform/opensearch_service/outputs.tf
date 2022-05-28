output "aws_elasticsearch_domain_arn" {
  value = aws_elasticsearch_domain.opensearch.arn
}
output "domain-name" {
  value = aws_elasticsearch_domain.opensearch.domain_name
}