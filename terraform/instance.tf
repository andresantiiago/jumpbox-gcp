resource "google_service_account" "default" {
  account_id   = "instance-sa"
  display_name = "Custom SA for VM Instance"
}

data "template_file" "cloud_init" {
  template = "${file("${path.module}/../template/cloud-config.tpl")}"
}

data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = "${data.template_file.cloud_init.rendered}"
  }

}

resource "google_compute_instance" "default" {
  name         = local.env_vars.instance.name
  machine_type = local.env_vars.instance.type
  zone         = local.env_vars.tags.zone

  tags = local.tags

  boot_disk {
    initialize_params {
      size    = 25
      type    = "pd-standard"
      image   = local.env_vars.instance.image
      labels  = local.labels
    }
  }

  network_interface {
    network = "default"

    access_config {
      # Public IP
    }
  }

  metadata = {
    user-data = "${data.template_cloudinit_config.config.rendered}"
  }

  # metadata_startup_script = "sudo apt install cloud-init"

  service_account {
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }

  allow_stopping_for_update = true

}