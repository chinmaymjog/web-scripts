provider "google" {
}

data "google_compute_image" "my_image" {
  family  = "cj-custom-images"
  project = "cj-learn-gcp"
}

resource "google_compute_instance" "default" {
  name         = "my-instance"
  machine_type = "n2-standard-2"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.my_image.self_link
      labels = {
        my_label = "value"
      }
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    ssh-keys = "gcpuser:${file("../ssh-key.pub")}"
  }
}

output "public_ip" {
  value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}