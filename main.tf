# ==============================================================================
# Bigtable Instance Module - Main
# Creates and manages a Google Cloud Bigtable instance.
# ==============================================================================

resource "google_bigtable_instance" "this" {
  name                = local.instance_name
  instance_type       = var.bigtable_config.instance_type
  deletion_protection = var.bigtable_config.deletion_protection
  labels              = var.bigtable_config.labels

  lifecycle {
    precondition {
      condition     = length(local.instance_name) <= 30
      error_message = "Constructed instance name '${local.instance_name}' is ${length(local.instance_name)} characters, exceeding the GCP limit of 30. Shorten base_name or project_code."
    }
  }

  dynamic "cluster" {
    for_each = var.bigtable_config.cluster
    content {
      cluster_id   = cluster.value.cluster_id
      zone         = cluster.value.zone
      storage_type = cluster.value.storage_type

      # num_nodes is not applicable for DEVELOPMENT instances or when autoscaling is enabled
      num_nodes = (
        var.bigtable_config.instance_type == "DEVELOPMENT" ? null :
        var.bigtable_config.autoscaling_config == null ? cluster.value.num_nodes : null
      )

      dynamic "autoscaling_config" {
        for_each = (
          var.bigtable_config.instance_type != "DEVELOPMENT" &&
          var.bigtable_config.autoscaling_config != null
        ) ? [var.bigtable_config.autoscaling_config] : []
        content {
          min_nodes  = autoscaling_config.value.min_nodes
          max_nodes  = autoscaling_config.value.max_nodes
          cpu_target = autoscaling_config.value.cpu_target
        }
      }
    }
  }
}
