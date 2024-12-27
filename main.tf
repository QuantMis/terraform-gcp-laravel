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
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"

    access_config {}
  }

  metadata_startup_script = <<EOT
    touch test.py
    ssh-keyscan 20.205.243.166 >> ~/.ssh/known_hosts
    git clone https://github.com/QuantMis/laravel-sso-server.git
  EOT
}
resource "google_storage_bucket" "mybucket-3884196215" {
  name = "laravel-mybucket-3884196215"
  location = var.region
  storage_class = "standard"
  public_access_prevention = "enforced"
}

resource "google_sql_database_instance" "mysql_instance" {
    name = "laravel-mysql"
    region = var.region
    database_version = "MYSQL_8_0"
    settings {
        tier = "db-n1-standard-2"
    }
    deletion_protection = false
}

resource "google_sql_database" "laravel_database" {
  name     = "laravel-db"
  instance = google_sql_database_instance.mysql_instance.name
}

resource "google_sql_user" "my_user" {
  name     = "user"
  instance = google_sql_database_instance.mysql_instance.name
  password = "password"
  host = "%"
}


