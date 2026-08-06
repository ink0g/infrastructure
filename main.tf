terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.3"
    }
  }
}

variable "ssh_public_key" {
  type    = string
  default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILmTNAzABUZCbXhS83f5HsMBqp1FG3g+Ov+ZCvvRpCi1 ink@Bombita"
}

provider "libvirt" {
  uri = "qemu:///system"
}

# --- 1. ХРАНИЛИЩЕ БАЗОВОГО ОБРАЗА ---
resource "libvirt_volume" "ubuntu_base" {
  name   = "ubuntu-22.04-base.qcow2"
  pool   = "default"
  source = "https://cloud-images.ubuntu.com/jammy/20260802/jammy-server-cloudimg-amd64-disk-kvm.img"
  format = "qcow2"
}

# --- 2. ДИСКИ ДЛЯ МАШИН ---
resource "libvirt_volume" "vm_go_disk" {
  name           = "go_disk.qcow2"
  pool           = "default"
  base_volume_id = libvirt_volume.ubuntu_base.id 
  size           = 21474836480 
}

resource "libvirt_volume" "vm_metric_disk" {
  name           = "metrics_disk.qcow2"
  pool           = "default"
  base_volume_id = libvirt_volume.ubuntu_base.id 
  size           = 21474836480 
}

# --- 3. РАЗДЕЛЬНЫЕ CLOUD-INIT ДИСКИ (ISO) ---

resource "libvirt_cloudinit_disk" "go_init" {
  name = "go_init.iso"
  pool = "default"

  user_data = templatefile("${path.module}/cloud_init.cfg", {
    ssh_public_key = var.ssh_public_key
    hostname       = "go-vm"
  })

  network_config = templatefile("${path.module}/network_config.cfg", {})
}

resource "libvirt_cloudinit_disk" "metric_init" {
  name = "metric_init.iso"
  pool = "default"

  user_data = templatefile("${path.module}/cloud_init.cfg", {
    ssh_public_key = var.ssh_public_key
    hostname       = "metrics-vm"
  })

  network_config = templatefile("${path.module}/network_config.cfg", {})
}

# --- 4. ВИРТУАЛЬНЫЕ МАШИНЫ ---

resource "libvirt_domain" "go_vm" {
  name   = "go_vm"
  memory = "1024"
  vcpu   = 1

  cloudinit = libvirt_cloudinit_disk.go_init.id

  disk {
    volume_id = libvirt_volume.vm_go_disk.id
  }

  network_interface {
    network_name   = "default"
    wait_for_lease = true 
  }
}

resource "libvirt_domain" "metrics_vm" {
  name   = "metrics_vm" 
  memory = "2048"
  vcpu   = 1

  cloudinit = libvirt_cloudinit_disk.metric_init.id

  disk {
    volume_id = libvirt_volume.vm_metric_disk.id
  }

  network_interface {
    network_name   = "default"
    wait_for_lease = true 
  }
}

# --- 5. ВЫВОД ДИНАМИЧЕСКИХ IP ДЛЯ ANSIBLE ---
output "go_vm_ip" {
  value       = libvirt_domain.go_vm.network_interface[0].addresses[0]
  description = "Динамический IP адрес GO сервера"
}

output "metrics_vm_ip" {
  value       = libvirt_domain.metrics_vm.network_interface[0].addresses[0]
  description = "Динамический IP адрес сервера метрик"
}

