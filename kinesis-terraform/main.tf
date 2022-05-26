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

# module "api_gateway" {
#   source  = "./api_gateway"
#   name = "cargo-location"
#   path_name = "/cargo"

# }

module "kinesis_data_stream" {
  source = "./kinesis_data_stream"
  name   = "terraform-kinesis-test"
}

module "kinesis_firehose" {
  source         = "./kinesis_firehose"
  stream_arn     = module.kinesis_data_stream.stream_arn
  domain_arn     = module.opensearch_service.aws_elasticsearch_domain_arn
  domain-name    = module.opensearch_service.domain-name
  region         = "ap-northeast-2"
  account-id     = "728116505069"
  stream_name    = module.kinesis_data_stream.stream_name
  log_group_name = "DestinationDelivery"
}

module "opensearch_service" {
  source          = "./opensearch_service"
  domain_name     = "cargoitzy"
  es_version      = "OpenSearch_1.2"
  master_name     = "admin"
  master_password = "Gkgkgk12!"
}

