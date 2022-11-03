output "name" {
  description = "The VPC name."
  value       = var.name
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.this.arn
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

output "vpc_secondary_cidr_block" {
  description = "List of secondary CIDR block of the VPC"
  value       = var.secondary_cidr_blocks
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = try(aws_internet_gateway.this.*.arn[0], null)
}

output "vpc_ipv6_cidr_block" {
  description = "The IPv6 CIDR block"
  value       = try(aws_vpc.this.ipv6_cidr_block, "")
}

output "env" {
  description = "The VPC Environment"
  value       = var.env
}
