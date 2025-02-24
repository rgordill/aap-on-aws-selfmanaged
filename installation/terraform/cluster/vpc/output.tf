output "vpc_id" {
  value = data.aws_vpc.cluster_vpc.id
}

output "az_to_private_subnet_id" {
  value = zipmap(data.aws_subnet.private.*.availability_zone, data.aws_subnet.private.*.id)
}

output "az_to_public_subnet_id" {
  value = zipmap(data.aws_subnet.public.*.availability_zone, data.aws_subnet.public.*.id)
}

output "public_subnet_ids" {
  value = data.aws_subnet.public.*.id
}

output "private_subnet_ids" {
  value = data.aws_subnet.private.*.id
}

output "controller_sg_id" {
  value = aws_security_group.controller.id
}

output "aws_lb_target_group_arns" {
  // The order of the list is very important because the consumers assume the 3rd item is the external aws_lb_target_group
  // Because of the issue https://github.com/hashicorp/terraform/issues/12570, the consumers cannot use a dynamic list for count
  // and therefore are force to implicitly assume that the list is of aws_lb_target_group_arns_length - 1, in case there is no api_external
  value = compact(
    concat(
      aws_lb_target_group.controller_internal.*.arn,
      aws_lb_target_group.controller_external.*.arn,
    ),
  )
}

output "aws_lb_target_group_arns_length" {
  // 2 for private endpoints and 1 for public endpoints
  value = "2"
}

output "aws_lb_controller_external_dns_name" {
  value = local.public_endpoints ? aws_lb.controller_external[0].dns_name : null
}

output "aws_lb_controller_external_zone_id" {
  value = local.public_endpoints ? aws_lb.controller_external[0].zone_id : null
}

output "aws_lb_controller_internal_dns_name" {
  value = aws_lb.controller_internal.dns_name
}

output "aws_lb_controller_internal_zone_id" {
  value = aws_lb.controller_internal.zone_id
}