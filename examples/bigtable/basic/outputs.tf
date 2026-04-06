output "instance_name" {
  description = "The name of the Bigtable instance."
  value       = module.bigtable_basic.instance_name
}

output "instance_type" {
  description = "The instance type of the Bigtable instance."
  value       = module.bigtable_basic.instance_type
}

output "instance_deletion_protection" {
  description = "Whether deletion protection is enabled."
  value       = module.bigtable_basic.instance_deletion_protection
}
