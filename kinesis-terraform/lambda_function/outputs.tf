output "lambda_function_" {
  value = aws_lambda_function.terraform_lambda_func.invoke_arn
}
output "lambda_function_name" {
  value = aws_lambda_function.terraform_lambda_func.function_name
}
