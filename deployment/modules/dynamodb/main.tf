resource "aws_dynamodb_table" "parking_tickets" {
  name           = "ParkingTickets"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "TicketId"

  attribute {
    name = "TicketId"
    type = "S" 
  }
}