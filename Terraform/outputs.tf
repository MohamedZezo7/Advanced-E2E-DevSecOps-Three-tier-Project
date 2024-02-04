output "instance_ip_addr" {
  value = "http://${aws_instance.ec2.public_ip}:8080"
}
