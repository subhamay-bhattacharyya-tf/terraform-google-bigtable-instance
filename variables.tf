# ==============================================================================
# Bigtable Instance Module - Variables
# ==============================================================================

variable "environment" {
  description = "Deployment environment. Must be one of: dev, test, prod."
  type        = string

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "environment must be one of: dev, test, prod."
  }
}

variable "project_code" {
  description = "Short project identifier used in resource naming."
  type        = string

  validation {
    condition     = length(var.project_code) > 0
    error_message = "project_code must not be empty."
  }
}

variable "region" {
  description = "GCP region for the provider configuration."
  type        = string
  default     = "us-central1"
}

variable "bigtable_config" {
  description = "Configuration object for the Google Bigtable instance."
  type = object({
    base_name           = string
    instance_type       = optional(string, "PRODUCTION")
    deletion_protection = optional(bool, true)
    cluster = list(object({
      cluster_id   = string
      zone         = string
      num_nodes    = optional(number, 1)
      storage_type = optional(string, "SSD")
    }))
    autoscaling_config = optional(object({
      min_nodes  = number
      max_nodes  = number
      cpu_target = number
    }), null)
    labels = optional(map(string), {})
  })

  validation {
    condition     = length(var.bigtable_config.base_name) > 0 && length(var.bigtable_config.base_name) <= 30
    error_message = "base_name must be between 1 and 30 characters."
  }

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.bigtable_config.base_name))
    error_message = "base_name may only contain lowercase letters, numbers, and hyphens."
  }

  validation {
    condition     = contains(["PRODUCTION", "DEVELOPMENT"], var.bigtable_config.instance_type)
    error_message = "instance_type must be one of: PRODUCTION, DEVELOPMENT."
  }

  validation {
    condition     = length(var.bigtable_config.cluster) > 0
    error_message = "At least one cluster must be provided."
  }

  validation {
    condition = alltrue([
      for c in var.bigtable_config.cluster :
      contains(["SSD", "HDD"], c.storage_type)
    ])
    error_message = "storage_type must be one of: SSD, HDD."
  }
}
