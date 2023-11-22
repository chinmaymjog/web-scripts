source "googlecompute" "ubuntu-2204-lts-docker" {
   project_id = "cj-learn-gcp"
   source_image = "ubuntu-2204-jammy-v20231030"
   source_image_family = "ubuntu-2204-lts"
   zone = "asia-south1-a"
   ssh_username = "gcpuser"
   machine_type = "e2-standard-2"
   image_name = "ubuntu-2204-lts-docker"
   image_description = "Rocky Linux 9 with docker. SSH & firewall hardned. Default user gcpuser"
   image_family = "cj-custom-images"
   account_file = "../cj-learn-gcp-1343df04052a.json"
}

build {
   name = "create_vm"
   sources = [
      "source.googlecompute.ubuntu-2204-lts-docker",
   ]
   provisioner "shell" {
      script = "ubuntu_provisioner.sh"
   }
}