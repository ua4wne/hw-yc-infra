data "yandex_compute_image" "os" {
  family = var.vm_family
}

resource "yandex_compute_instance" "vm-public" {
  name                      = "vm-public"
  hostname                  = "vm-public"
  platform_id               = var.vm_platform
  zone                      = var.default_zone

  resources {
    cores         = var.resources_vm["cores"]
    memory        = var.resources_vm["memory"]
    core_fraction = var.resources_vm["core_fraction"]
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.os.image_id
      size     = var.resources_vm["disk_size"]
      type     = var.resources_vm["disk_type"]
    }
  }

  metadata = {
    serial-port-enable = var.metadata_map.metadata.serial-port-enable
    ssh-keys           = "${var.vm_user}:${var.metadata_map.metadata.ssh-keys}"
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.public.id
    nat        = var.vm_nat
  }
  scheduling_policy {
    preemptible = var.vm_preemptible
  }
}