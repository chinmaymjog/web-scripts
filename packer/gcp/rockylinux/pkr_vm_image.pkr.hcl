variables {
   pkr_subscription_id = env("ARM_SUBSCRIPTION_ID")
   pkr_client_id = env("ARM_CLIENT_ID")
   pkr_client_secret =  env("ARM_CLIENT_SECRET")
   pkr_rg =  env("hub_rgname")
   os_image_publisher = env("image_publisher")
   os_image_offer = env("image_offer")
   os_image_sku = env("image_sku")
   image_name = env ("image_name") 
   image_location = env ("image_location")
}

source "azure-arm" "os-image" {
   os_type = "Linux"
   image_publisher = var.os_image_publisher
   image_offer = var.os_image_offer
   image_sku = var.os_image_sku
   managed_image_name = var.image_name
   managed_image_resource_group_name = var.pkr_rg
   location = var.image_location
   vm_size="Standard_B2s"

  subscription_id = var.pkr_subscription_id
  client_id = var.pkr_client_id
  client_secret = var.pkr_client_secret
}

build {
    name = "create_vm"
    sources = [
    "source.azure-arm.os-image",
    ]

    provisioner "shell" {
    script = "./pkr_vm_provisioner.sh"
    expect_disconnect = "true"
}
}