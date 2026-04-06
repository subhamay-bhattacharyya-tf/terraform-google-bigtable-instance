variable "environment" {
  type    = string
  default = "prod"
}

variable "project_code" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "base_name" {
  type = string
}

variable "deletion_protection" {
  type    = bool
  default = true
}
