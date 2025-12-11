
data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_instance" "web" {
  count = 2
  
  name        = "web-${count.index + 1}"  
  platform_id = "standard-v3"
  zone        = var.default_zone

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
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
}

output "web_vm_ips" {
  value = {
    for idx, vm in yandex_compute_instance.web :
    vm.name => vm.network_interface.0.nat_ip_address
  }
  description = "Внешние IP адреса ВМ web-1 и web-2"
}
