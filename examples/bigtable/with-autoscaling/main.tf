module "bigtable_autoscaling" {
  source = "../../.."

  environment  = var.environment
  project_code = var.project_code
  region       = var.region

  bigtable_config = {
    base_name           = var.base_name
    instance_type       = "PRODUCTION"
    deletion_protection = false

    cluster = [
      {
        cluster_id   = "${var.project_code}-${var.base_name}-c1"
        zone         = "${var.region}-a"
        storage_type = "SSD"
      }
    ]

    autoscaling_config = {
      min_nodes  = 1
      max_nodes  = 5
      cpu_target = 60
    }
  }
}
