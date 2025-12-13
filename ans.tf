resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inv.tftpl", {
    web_instances = [
      {
        name = yandex_compute_instance.web[0].name
        fqdn = yandex_compute_instance.web[0].fqdn
        zone = yandex_compute_instance.web[0].zone
        network_interface = [{
          nat_ip_address = yandex_compute_instance.web[0].network_interface[0].nat_ip_address
        }]
      },
      {
        name = yandex_compute_instance.web[1].name
        fqdn = yandex_compute_instance.web[1].fqdn
        zone = yandex_compute_instance.web[1].zone
        network_interface = [{
          nat_ip_address = yandex_compute_instance.web[1].network_interface[0].nat_ip_address
        }]
      }
    ]
    
    db_instances = [
      {
        name = yandex_compute_instance.db["main"].name
        fqdn = yandex_compute_instance.db["main"].fqdn
        zone = yandex_compute_instance.db["main"].zone
        network_interface = [{
          nat_ip_address = yandex_compute_instance.db["main"].network_interface[0].nat_ip_address
        }]
      },
      {
        name = yandex_compute_instance.db["replica"].name
        fqdn = yandex_compute_instance.db["replica"].fqdn
        zone = yandex_compute_instance.db["replica"].zone
        network_interface = [{
          nat_ip_address = yandex_compute_instance.db["replica"].network_interface[0].nat_ip_address
        }]
      }
    ]
    
    storage_instances = [
      {
        name = yandex_compute_instance.storage.name
        fqdn = yandex_compute_instance.storage.fqdn
        zone = yandex_compute_instance.storage.zone
        network_interface = [{
          nat_ip_address = yandex_compute_instance.storage.network_interface[0].nat_ip_address
        }]
      }
    ]
  })
  
  filename = "${abspath(path.module)}/for.ini"
}

output "instance_info" {
  value = {
    web_instances = [
      {
        name = yandex_compute_instance.web[0].name
        zone = yandex_compute_instance.web[0].zone
        original_fqdn = yandex_compute_instance.web[0].fqdn
      },
      {
        name = yandex_compute_instance.web[1].name
        zone = yandex_compute_instance.web[1].zone
        original_fqdn = yandex_compute_instance.web[1].fqdn
      }
    ]
    db_instances = [
      {
        name = yandex_compute_instance.db["main"].name
        zone = yandex_compute_instance.db["main"].zone
        original_fqdn = yandex_compute_instance.db["main"].fqdn
      },
      {
        name = yandex_compute_instance.db["replica"].name
        zone = yandex_compute_instance.db["replica"].zone
        original_fqdn = yandex_compute_instance.db["replica"].fqdn
      }
    ]
    storage_instance = {
      name = yandex_compute_instance.storage.name
      zone = yandex_compute_instance.storage.zone
      original_fqdn = yandex_compute_instance.storage.fqdn
    }
  }
}