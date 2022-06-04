data "aws_caller_identity" "current" {}

terraform {
  ### Github Action provider
  cloud {
    organization = "hengsgg"

    workspaces {
      name = "cargoitzy"
    }
  }
  ###

  # ### local test provider
  # required_providers {
  #   aws = {
  #     source  = "hashicorp/aws"
  #     version = "= 3.74.2"
  #   }
  # }
  ###
}
provider "aws" {
  region = var.region
}


module "api_gateway" {
  source                = "./api_gateway"
  rest_api_name         = "cargo-location-post" //게이트웨이 이름
  path_name_driver      = "location"            // 게이트웨이 리소스 이름
  path_name_user        = "delivery"
  region                = var.region                                  // 리전
  account               = data.aws_caller_identity.current.account_id //aws 계정 번호
  stream_name           = module.kinesis_data_stream.stream_name      //키네시스 데이터 스트림 이름(변경 x)                                       // AWS 서비스
  http_method_driver    = "POST"
  deployment_stage_name = "production"
  lambda_invoke_arn     = module.lambda_function.lambda_function_
  function_name         = module.lambda_function.lambda_function_name
}

module "kinesis_data_stream" {
  source = "./kinesis_data_stream"
  name   = "cargo-data-stream" //데이터 스트림 이름
}

module "kinesis_firehose" {
  source          = "./kinesis_firehose"
  name            = "cargo-firehose"         // 키네시스 firehose 이름
  bucket_name     = "cargo-all-logs-hengsgg" // @@버킷이름을 정해주세요@@
  destination     = "elasticsearch"
  es_index_name   = "location"
  stream_arn      = module.kinesis_data_stream.stream_arn                  // 데이터스트림 arn
  domain_arn      = module.opensearch_service.aws_elasticsearch_domain_arn // opensearch arn
  region          = var.region                                             // 리전
  account-id      = data.aws_caller_identity.current.account_id
  stream_name     = module.kinesis_data_stream.stream_name
  log_stream_name = var.log_stream_name // cloudwatch 로그 스트림 이름
}

module "opensearch_service" {
  source          = "./opensearch_service"
  domain_name     = "cargo-itzy" //도메인 이름
  instance_type   = var.instance_type
  es_version      = var.es_version
  master_name     = var.master_name    //user name
  master_password = var.master_password //user password
}

module "lambda_function" {
  source          = "./lambda_function"
  function_name   = "cargo_location"
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.9"
  region          = var.region
  function_zip    = "hello-python.zip"
  source_dir      = "search-app"
  domain_endpoint = module.opensearch_service.domain-endpoint


}
