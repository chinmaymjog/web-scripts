variables {
   pkr_subscription_id = env("ARM_SUBSCRIPTION_ID")
   pkr_client_id = env("ARM_CLIENT_ID")
   pkr_client_secret =  env("ARM_CLIENT_SECRET")
   pkr_rg =  env("RG_NAME")
   pkr_location = env("LOCATION")
}

source "azure-arm" "ubuntu-22_4-docker" {
   os_type = "Linux"
   image_publisher = "canonical"
   image_offer = "0001-com-ubuntu-server-jammy"
   image_sku = "22_04-lts"
   managed_image_name = "ubuntu-22_4-docker"
   managed_image_resource_group_name = var.pkr_rg
   location = var.pkr_location
   vm_size="Standard_B2s"
   subscription_id = var.pkr_subscription_id
   client_id = var.pkr_client_id
   client_secret = var.pkr_client_secret
}

build {
   name = "create_vm"
   sources = [
      "source.azure-arm.ubuntu-22_4-docker",
   ]
   provisioner "shell" {
      script = "ubuntu_provisioner.sh"
   }
}