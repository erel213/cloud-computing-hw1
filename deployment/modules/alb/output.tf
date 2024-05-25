output "target_group_arn" {
    description = "value of the target group arn"
    value = aws_lb_target_group.parking_lot_tagret_group.arn
}

output "alb_security_group_id" {
    description = "value of the alb security group id"
    value = aws_security_group.alb_security_group.id
}