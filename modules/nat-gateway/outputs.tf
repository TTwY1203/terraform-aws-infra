output "natgw_ids" {
  description = "The ID of the NAT Gateway."
  value       = aws_nat_gateway.this[*].id
}

output "connectivity_type" {
  description = "Connectivity type for the NAT Gateway. Vaild values are private and public"
  value       = aws_nat_gateway.this[*].connectivity_type
}

output "eip_id" {
  description = "The Allocation ID of the Elastic IP address for the gateway."
  value       = aws_nat_gateway.this[*].allocation_id
}

output "eni_id" {
  description = "The ENI ID of the network interface created by the NAT gateway."
  value       = aws_nat_gateway.this[*].network_interface_id
}

output "public_ip" {
  description = "The public IP address of the NAT Gateway."
  value       = aws_nat_gateway.this[*].public_ip
}

output "private_ip" {
  description = "The private IP address of the NAT Gateway."
  value       = aws_nat_gateway.this[*].private_ip
}

output "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  value       = var.single_nat_gateway
}
