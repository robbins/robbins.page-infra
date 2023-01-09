resource "google_compute_instance" "robbins-page-webserver" {
  name = "robbins-page-webserver"
  machine_type = var.machine_type
  zone = var.zone

  boot_disk {
    initialize_params {
      image = module.nixos_image_custom.self_link
      size = 20
    }
  }

  tags = [ "http-server", "https-server" ]

  network_interface {
    network = var.network_name
    access_config {
      network_tier = "STANDARD"
    }
  }

  metadata = {
    enable-oslogin = "TRUE"
    enable-oslogin-2fa = "FALSE"
  }

  allow_stopping_for_update = true
}

resource "google_compute_firewall" "firewall_rules" {
  project = var.project
  name = "allow-all-http-https"
  network = var.network_name
  description = "Allows HTTP & HTTPS traffic"

  allow {
    protocol = "tcp"
    ports = [ "80", "443" ]
  }
  source_ranges = [ "0.0.0.0/0"]
}

module "deploy_nixos" {
  source = "git::https://github.com/robbins/terraform-nixos.git//deploy_nixos?ref=8f00bdaf514c144e2a75b3e4e2ea536da8c813db"
  flake = true
  nixos_config = "robbins-page-webserver"
  target_host = google_compute_instance.robbins-page-webserver.network_interface[0].access_config[0].nat_ip
  target_user = "nejrobbins_gmail_com"
  build_on_target = false
  ssh_private_key = fileexists(var.INSTANCE_SSH_KEY) == true ? file(var.INSTANCE_SSH_KEY) : var.INSTANCE_SSH_KEY
  ssh_agent = false
  keys = {
    "robbins.page.pem" = fileexists(var.ROBBINS_PAGE_PEM) == true ? file(var.ROBBINS_PAGE_PEM) : var.ROBBINS_PAGE_PEM
    "robbins.page.key" = fileexists(var.ROBBINS_PAGE_KEY) == true ? file(var.ROBBINS_PAGE_KEY) : var.ROBBINS_PAGE_KEY
  }
}
