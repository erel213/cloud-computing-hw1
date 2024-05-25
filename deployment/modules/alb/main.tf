resource "aws_lb" "application_load_balancer" {
    name = var.name
    internal = false
    load_balancer_type = "application"
    subnets = var.public_subnet_ids
    security_groups = [aws_security_group.alb_security_group.id]
}

resource "aws_security_group" "alb_security_group" {
  name = "Allow HTTPS"
  description = "Allow HTTPS inbound traffic"
  vpc_id = var.vpc_id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] 
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] 
  }

  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"] # Allow outbound traffic to anywhere
  }
}


resource "aws_lb_target_group" "parking_lot_tagret_group" {
  name     = "parking-lot-tagret-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"
  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.parking_lot_tagret_group.arn
  }
}