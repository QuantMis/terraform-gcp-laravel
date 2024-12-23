terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}

provider "google" {
  project     = "intro-2-terraform"
  credentials = file("cred/intro-2-terraform-005e83ca8205.json")
  region      = var.region 
  zone        = var.zone
}

resource "google_compute_instance" "laravel_vm" {
  name         = "laravel-vm-instance"
  machine_type = "e2-micro"
  zone         = "asia-southeast1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"

    access_config {}
  }
}


