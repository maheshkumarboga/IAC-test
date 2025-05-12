output "instance_ip_addr" {
  value       = aws_vpc.main.id
  description = "The private IP address of the VPC."
}
