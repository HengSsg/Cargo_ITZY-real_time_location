terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

module "api_gateway" {
  source  = "./api_gateway"
  name = "cargo-location"  //게이트웨이 이름
  path_name = "location"  // 리소스 이름
  region = "ap-northeast-2"  // 리전
  account = "728116505069"  //aws 계정 번호
  stream_name = module.kinesis_data_stream.stream_name  //키네시스 데이터 스트림 이름(변경 x)
  integration_type = "AWS" // AWS 서비스
}

module "kinesis_data_stream" {
  source = "./kinesis_data_stream"
  name   = "terraform-kinesis-test" //데이터 스트림 이름
}

module "kinesis_firehose" {
  source         = "./kinesis_firehose"
  stream_arn     = module.kinesis_data_stream.stream_arn  //데이터스트림 arn
  domain_arn     = module.opensearch_service.aws_elasticsearch_domain_arn //opensearch arn
  domain-name    = module.opensearch_service.domain-name // opensearch name
  region         = "ap-northeast-2"  //리전
  account-id     = "728116505069"
  stream_name    = module.kinesis_data_stream.stream_name
  log_group_name = "DestinationDelivery"  //cloudwatch 로그그룹 이름
  es_index_name = "test"
}

module "opensearch_service" {
  source          = "./opensearch_service"
  instance_type = "t3.small.elasticsearch"
  domain_name     = "cargoitzy" //도메인 이름
  es_version      = "OpenSearch_1.2" //opensearch name
  master_name     = "admin"  //user name
  master_password = "Gkgkgk12!" //user password
}

