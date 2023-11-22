source "googlecompute" "rockylinux-9-docker" {
   project_id = "cj-learn-gcp"
   source_image = "rocky-linux-9-v20231115"
   source_image_family = "rocky-linux-9"
   zone = "asia-south1-a"
   ssh_username = "gcpuser"
   machine_type = "e2-standard-2"
   image_name = "rockylinux-9-docker"
   image_description = "Rocky Linux 9 with docker. SSH & firewall hardned. Default user gcpuser"
   image_family = "cj-custom-images"
   account_file = "../cj-learn-gcp-1343df04052a.json"
}

build {
   name = "create_vm"
   sources = [
      "source.googlecompute.rockylinux-9-docker",
   ]
   provisioner "shell" {
      script = "rockylinux_provisioner.sh"
   }
}