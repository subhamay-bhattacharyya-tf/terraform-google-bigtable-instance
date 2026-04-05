# ==============================================================================
# Bigtable Instance Module - Locals
# ==============================================================================

locals {
  instance_name = "${var.project_code}-${var.bigtable_config.base_name}-${var.region}-${var.environment}"
}
