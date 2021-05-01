provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id = var.cloud_id
  folder_id = var.folder_id
  zone = var.zone
}

data "yandex_compute_image" "image" {
  family = "ubuntu-1804-lts"
}

resource "yandex_compute_instance" "node" {
  count = var.count_app * 3
  name = "node-${count.index}"

  resources {
    cores = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image
      size = 40
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat = true
  }

  metadata = {
    user-data = file("files/metadata.yaml")
  }
}
