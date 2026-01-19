output "work_orders_table_name" {
  value = aws_dynamodb_table.work_orders.name
}

output "work_orders_table_arn" {
  value = aws_dynamodb_table.work_orders.arn
}
