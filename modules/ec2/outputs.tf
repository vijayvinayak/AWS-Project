output "security_group_id" {
  value = aws_security_group.web.id
}

output "instance_ids" {
  value = aws_instance.instance.*.id
}

# output "example_role" {
#   value = aws_iam_role.e2_role.name
# }