resource "aws_lb" "application_load_balancer" {
    name = var.name
    internal = false
    load_balancer_type = "application"
    subnets = var.public_subnet_ids
}

resource "aws_security_group" "alb_security_group" {
  name = "Allow HTTPS"
  description = "Allow HTTPS inbound traffic"
  vpc_id = var.vpc_id

  tags = {
    Name = "Allow HTTPS"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.alb_security_group.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0" 
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.alb_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}