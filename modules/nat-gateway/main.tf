################################################################################
# NAT Gateway
################################################################################

locals {
  nat_gateway_ips   = var.reuse_nat_ips ? var.external_nat_ip_ids : try(aws_eip.nat[*].id, [])
  nat_gateway_count = var.single_nat_gateway ? 1 : length(var.public_subnets)
}

resource "aws_eip" "nat" {
  count = var.enable_nat_gateway && var.reuse_nat_ips == false ? local.nat_gateway_count : 0

  vpc = true

  tags = merge(
    {
      "Name" = format(
        "${var.name}-${var.env}-${substr(element(var.public_subnets.*.availability_zone, count.index), 14, 1)}-eip"
      )
    },
    var.tags,
    var.nat_eip_tags,
  )
}

resource "aws_nat_gateway" "this" {
  count = var.enable_nat_gateway ? local.nat_gateway_count : 0

  allocation_id = element(local.nat_gateway_ips, var.single_nat_gateway ? 0 : count.index)
  subnet_id     = element(var.public_subnets.*.id, var.single_nat_gateway ? 0 : count.index)

  tags = merge(
    {
      "Name" = format(
        "${var.name}-${var.env}-nat-${substr(element(var.public_subnets.*.availability_zone, count.index), 14, 1)}"
      )
    },
    var.tags,
    var.nat_gateway_tags,
  )
}
