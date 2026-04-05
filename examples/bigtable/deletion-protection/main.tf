module "bigtable_deletion_protection" {
  source = "../../.."

  environment  = var.environment
  project_code = var.project_code
  region       = var.region

  bigtable_config = {
    base_name           = var.base_name
    instance_type       = "PRODUCTION"
    deletion_protection = true

    cluster = [
      {
        cluster_id   = "${var.project_code}-${var.base_name}-c1"
        zone         = "${var.region}-a"
        num_nodes    = 1
        storage_type = "SSD"
      }
    ]

    labels = {
      env  = "prod"
      team = "platform"
    }
  }
}
