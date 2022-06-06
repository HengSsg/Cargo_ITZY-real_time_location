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
variable "log_stream_name" {
  type    = string
  default = "DestinationDelivery"
}
variable "master_name" {
  type        = string
  description = "마스터 유저 이름을 적어주세요"
}
variable "master_password" {
  type        = string
  description = "마스터 유저 비밀번호를 적어주세요"
}
