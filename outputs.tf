# ==============================================================================
# Bigtable Instance Module - Outputs
# ==============================================================================

output "instance_id" {
  description = "The unique ID of the Bigtable instance."
  value       = google_bigtable_instance.this.id
}

output "instance_name" {
  description = "The name of the Bigtable instance."
  value       = google_bigtable_instance.this.name
}

output "instance_project" {
  description = "The project where the Bigtable instance was created."
  value       = google_bigtable_instance.this.project
}

output "instance_type" {
  description = "The instance type of the Bigtable instance (PRODUCTION or DEVELOPMENT)."
  value       = google_bigtable_instance.this.instance_type
}

output "instance_deletion_protection" {
  description = "Whether deletion protection is enabled on the Bigtable instance."
  value       = google_bigtable_instance.this.deletion_protection
}
