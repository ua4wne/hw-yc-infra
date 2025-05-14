resource "yandex_compute_instance" "nat" {
  name                      = "nat-vm"
  hostname                  = "nat-vm"
  platform_id               = var.vm_platform
  zone                      = var.default_zone

  resources {
    cores         = var.resources_vm["cores"]
    memory        = var.resources_vm["memory"]
    core_fraction = var.resources_vm["core_fraction"]
  }

  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
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
    ip_address = "192.168.10.254"
  }
  scheduling_policy {
    preemptible = var.vm_preemptible
  }
}