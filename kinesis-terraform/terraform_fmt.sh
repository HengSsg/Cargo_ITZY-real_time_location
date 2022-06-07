#!bin/bash

terraform fmt
terraform fmt ./api_gateway
terraform fmt ./kinesis_data_stream
terraform fmt ./kinesis_firehose
terraform fmt ./opensearch_service
terraform fmt ./lambda_function
terraform fmt ./dynamoDB