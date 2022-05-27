data "aws_caller_identity" "current" {}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
    required_version = ">= 0.12"
}

provider "aws" {
  region = var.region
}

module "api_gateway" {
  source           = "./api_gateway"
  name             = "cargo-location"                            //게이트웨이 이름
  path_name        = "location"                                  // 게이트웨이 리소스 이름
  region           = var.region                                  // 리전
  account          = data.aws_caller_identity.current.account_id //aws 계정 번호
  stream_name      = module.kinesis_data_stream.stream_name      //키네시스 데이터 스트림 이름(변경 x)
  integration_type = "AWS"                                       // AWS 서비스
  http_method      = "POST"
  stage_name       = "production"
}

module "kinesis_data_stream" {
  source = "./kinesis_data_stream"
  name   = "terraform-kinesis-test" //데이터 스트림 이름
}

module "kinesis_firehose" {
  source          = "./kinesis_firehose"
  name            = "terraform-kinesis-firehose-test-stream"
  stream_arn      = module.kinesis_data_stream.stream_arn                  //데이터스트림 arn
  domain_arn      = module.opensearch_service.aws_elasticsearch_domain_arn //opensearch arn
  domain-name     = module.opensearch_service.domain-name                  // opensearch name
  region          = var.region                                             //리전
  account-id      = data.aws_caller_identity.current.account_id
  stream_name     = module.kinesis_data_stream.stream_name
  log_stream_name = "DestinationDelivery"                                  //cloudwatch 로그 스트림 이름
  es_index_name   = module.opensearch_service.es_endpoint
  bucket_name     = "tf-test-bucket-cargo-buc"   // 버킷이름을 정해주세요
}

module "opensearch_service" {
  source          = "./opensearch_service"
  instance_type   = var.instance_type
  domain_name     = "cargoitzy"             //도메인 이름
  es_version      = var.es_version
  master_name     = "admin"                 //user name
  master_password = "Gkgkgk12!"             //user password
  es_endpoint     = "test"
}

