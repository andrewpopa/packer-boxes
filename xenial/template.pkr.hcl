variable "build_name" {
  type    = string
  default = "xenial64"
}

variable "build_cpu_cores" {
  type    = string
  default = "2"
}

variable "build_memory" {
  type    = string
  default = "2048"
}

variable "disk_size" {
  type    = string
  default = "204800"
}

variable "ssh_username" {
  type = string
  default = "vagrant"
}

variable "ssh_password" {
  type = string
  default = "vagrant"
}

variable "ssh_port" {
  type = string
  default = "22"
}

source "virtualbox-iso" "step_1" {
  boot_command     = [
    "<enter><f6><esc><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
    "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
    "debian-installer=en_US ",
    "auto locale=en_US kbd-chooser/method=us ",
    "hostname=${var.build_name} ",
    "fb=false debconf/frontend=noninteractive ",
    "keyboard-configuration/modelcode=SKIP ",
    "keyboard-configuration/layout=USA ",
    "keyboard-configuration/variant=USA ",
    "console-setup/ask_detect=false ",
    "initrd=/install/initrd.gz -- <enter>"
  ]
  vm_name              = "${var.build_name}-vbox"
  guest_additions_path = "VBoxGuestAdditions.iso",
  boot_wait            = "5s"
  disk_size            = var.disk_size
  guest_os_type        = "Ubuntu_64"
  http_directory       = "./http"
  iso_checksum         = "sha256:b23488689e16cad7a269eb2d3a3bf725d3457ee6b0868e00c8762d3816e25848"
  iso_url              = "https://releases.ubuntu.com/xenial/ubuntu-16.04.7-server-amd64.iso"
  shutdown_command     = "echo 'vagrant' | sudo -S shutdown -P now"
  ssh_username         = var.ssh_username
  ssh_password         = var.ssh_password
  ssh_port             = var.ssh_port
  ssh_timeout          = "10m"
  vboxmanage           = [[ "modifyvm", "${var.build_name}-vbox","--memory","${var.build_memory}"],["modifyvm", "${var.build_name}-vbox", "--cpus","${var.build_cpu_cores}"]]
}

build {
  sources = ["source.virtualbox-iso.step_1"]

  provisioner "shell" {
    execute_command = "echo 'vagrant' | sudo -S sh '{{.Path}}'"
    script = "scripts/packages.sh"
    expect_disconnect = true
  }
  
  provisioner "shell" {
    execute_command = "echo 'vagrant' | sudo -S sh '{{.Path}}'"
    script = "scripts/vagrant.sh"
  }

  provisioner "shell" {
    execute_command = "echo 'vagrant' | sudo -S sh '{{.Path}}'"
    script = "scripts/virtualbox.sh"
    expect_disconnect = true
  }

  provisioner "shell" {
    execute_command = "echo 'vagrant' | sudo -S sh '{{.Path}}'"
    script = "scripts/cleanup.sh"
  }

  post-processor "manifest" {
    output = "stage-1-manifest.json"
  }

  post-processor "vagrant" {
    output = "${var.build_name}.box"
  }
}
