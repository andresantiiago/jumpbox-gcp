locals {
  env_vars      = yamldecode(file("../vars/vars.yaml"))
  labels        = local.env_vars.tags
  tags          = [
    local.env_vars.tags.region,
    local.env_vars.tags.zone,
    local.env_vars.tags.purpose,
    local.env_vars.tags.project
  ]
}

provider "google" {
  project = local.env_vars.tags.project
}

terraform {
  backend "gcs" {
    bucket = "jumpbox_automation"
    prefix = "jumpbox_terraform"
  }
}