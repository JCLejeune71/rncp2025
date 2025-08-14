output "vpc" {
  value = module.vpc
}

output "sg_pub_id" {
  value = aws_security_group.public_sg.id
}

output "sg_web_id" {
  value = aws_security_group.web_sg.id
}
