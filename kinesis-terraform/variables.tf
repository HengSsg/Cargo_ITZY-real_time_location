variable "instance_type" {
  type        = string
  default     = "t3.small.elasticsearch"
  description = "opensearch instance type"
}
variable "es_version" {
  type        = string
  default     = "OpenSearch_1.2"
  description = "opensearch service version"
}
variable "region" {
  type        = string
  default     = "ap-northeast-2"
  description = "AWS use region"
}