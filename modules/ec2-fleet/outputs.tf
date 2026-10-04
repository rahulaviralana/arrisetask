output "instance_ids" {
  description = "Map of instance name to instance ID"
  value       = { for k, v in aws_instance.fleet : k => v.id }
}

output "private_ips" {
  description = "Map of instance name to private IP"
  value       = { for k, v in aws_instance.fleet : k => v.private_ip }
}
