locals {
  global_vars        = yamldecode(file("../vars/vars.yaml"))
}
provider "google" {
  project                     = local.global_vars.project
}

terraform {
  backend "gcs" {
    bucket = "jumpbox_automation"
    prefix = "jumpbox_terraform"
  }
}