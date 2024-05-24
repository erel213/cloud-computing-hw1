output "public_subnet_ids" {
  description = "value of the public subnet ids"
  value = [aws_subnet.public-1.id, aws_subnet.public-2.id]
}

output "vpc_id" {
  description = "value of the vpc id"
  value = aws_vpc.main.id
  
}