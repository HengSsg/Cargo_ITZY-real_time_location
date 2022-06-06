resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "DeliverINFO"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "truckerId"
  range_key      = ""

  attribute {
    name = "truckerId"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }


  tags = {
    Name        = "dynamodb-table-delivery"
    Environment = "production"
  }
}