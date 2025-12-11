resource "yandex_compute_disk" "storage" {
  count = 3
  
  name     = "storage-disk-${count.index + 1}"  # storage-disk-1, storage-disk-2, storage-disk-3
  type     = "network-hdd"
  zone     = var.default_zone
  size     = 1  # 1 ГБ
  block_size = 4096

  labels = {
    environment = "develop"
    managed-by  = "terraform"
    purpose     = "storage"
  }
}


data "yandex_compute_image" "ubuntu_storage" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_instance" "storage" {
  name        = "storage"
  platform_id = "standard-v3"
  zone        = var.default_zone

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_storage.image_id
      size     = 10
      type     = "network-hdd"
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILtJ0WBY0tIdMLfAsuzBcsfGnh2a7a0Cy58ky65Ft85P ruslan92mv@gmail.com"
  }

  labels = {
    role      = "storage-server"
    managed-by = "terraform"
  }

  dynamic "secondary_disk" {
    for_each = { for idx, disk in yandex_compute_disk.storage : idx => disk.id }
    
    content {
      disk_id = secondary_disk.value  # ID диска
    }
  }
}

