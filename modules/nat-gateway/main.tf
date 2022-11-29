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

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    {
      "Name" = format(
        "${var.name}-${var.env}-nat-%s-eip",
        substr(element(var.azs, count.index), -1, 1),
      )
    },
    var.tags,
    var.nat_eip_tags,
  )
}

resource "aws_nat_gateway" "this" {
  count = var.enable_nat_gateway ? local.nat_gateway_count : 0

  allocation_id = element(local.nat_gateway_ips, var.single_nat_gateway ? 0 : count.index)
  subnet_id     = element(var.public_subnets, var.single_nat_gateway ? 0 : count.index)

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    {
      "Name" = format(
        "${var.name}-${var.env}-nat-%s",
        substr(element(var.azs, count.index), -1, 1),
      )
    },
    var.tags,
    var.nat_gateway_tags,
  )
}
