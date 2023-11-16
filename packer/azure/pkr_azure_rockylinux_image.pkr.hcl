variables {
   pkr_subscription_id = env("ARM_SUBSCRIPTION_ID")
   pkr_client_id = env("ARM_CLIENT_ID")
   pkr_client_secret =  env("ARM_CLIENT_SECRET")
   pkr_rg =  env("RG_NAME")
   pkr_location = env("LOCATION")
}

source "azure-arm" "rockylinux-9-docker" {
   os_type = "Linux"
   image_publisher = "erockyenterprisesoftwarefoundationinc1653071250513"
   image_offer = "rockylinux-9"
   image_sku = "rockylinux-9"
   managed_image_name = "rockylinux-9-docker"
   managed_image_resource_group_name = var.pkr_rg
   location = var.pkr_location
   vm_size="Standard_B2s"
   subscription_id = var.pkr_subscription_id
   client_id = var.pkr_client_id
   client_secret = var.pkr_client_secret
   plan_info {
      plan_name = "rockylinux-9"
      plan_product = "rockylinux-9"
      plan_publisher ="erockyenterprisesoftwarefoundationinc1653071250513"
   }
}

build {
   name = "create_vm"
   sources = [
      "source.azure-arm.rockylinux-9-docker",
   ]
   provisioner "shell" {
      script = "rockylinux_provisioner.sh"
   }
}