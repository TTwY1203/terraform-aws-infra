################################################################################
# Route Tables
################################################################################

################################################################################
# Public route
################################################################################
resource "aws_route_table" "public" {
  count = length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = var.vpc_id

  tags = merge(
    { "Name" = "${var.name}-${var.env}-rtb-pub" },
    var.tags,
    var.public_route_table_tags,
  )
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public[0].id
}

resource "aws_route" "public_internet_gateway" {
  count = length(var.public_subnets) > 0 ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gateway_id
}

################################################################################
# Private route
# There are as many routing tables as the number of NAT gateways
################################################################################
resource "aws_route_table" "private" {
  count = var.single_nat_gateway ? 1 : length(var.natgw_ids)

  vpc_id = var.vpc_id

  tags = merge(
    { "Name" = var.single_nat_gateway ? "${var.name}-${var.env}-rtb-pri" : format(
      "${var.name}-${var.env}-rtb-pri-%s",
      substr(element(var.azs, count.index), -1, 1),
      )
    },
    var.tags,
    var.private_route_table_tags,
  )
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  subnet_id = element(aws_subnet.private[*].id, count.index)
  route_table_id = element(
    aws_route_table.private[*].id,
    var.single_nat_gateway ? 0 : count.index,
  )
}

resource "aws_route" "private_nat" {
  count = length(var.private_subnets) > 0 ? length(var.private_subnets) : 0
  route_table_id = element(
    aws_route_table.private[*].id,
    var.single_nat_gateway ? 0 : count.index,
  )
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = element(
    aws_nat_gateway.nat.*.id,
    var.single_nat_gateway ? 0 : count.index,
  )
}
