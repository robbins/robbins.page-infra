locals {
  ipv4 = google_compute_instance.robbins-page-webserver.network_interface[0].access_config[0].nat_ip
}

module "google_compute_image" {
  source = "git::https://github.com/robbins/terraform-nixos-ng.git//gce-image"
}

resource "google_compute_instance" "robbins-page-webserver" {
  name = "robbins-page-webserver"
  machine_type = var.machine_type
  zone = var.zone

  boot_disk {
    device_name = "boot_disk"
    initialize_params {
      image = module.google_compute_image.gce-image
      size = 20
      type = "pd-standard"
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

# This ensures that the instance is reachable via `ssh` before we deploy NixOS
resource "null_resource" "example" {
  provisioner "remote-exec" {
    connection {
      host = local.ipv4
      user = "nejrobbins_gmail_com"
      private_key = var.INSTANCE_SSH_KEY
    }

    inline = [ ":" ]
  }
}

module "nixos" {
  source = "git::https://github.com/robbins/terraform-nixos-ng.git//nixos"

  host = "nejrobbins_gmail_com@${local.ipv4}"

  flake = ".#robbins-page-webserver"

  arguments = [
    # You can build on another machine, including the target machine, by
    # enabling this option, but if you build on the target machine then make
    # sure that the firewall and security group permit outbound connections.
  ]

  ssh_options = "-o StrictHostKeyChecking=accept-new -o ControlMaster=no -t -i /home/runner/.ssh/key"

  depends_on = [ null_resource.example ]
}
