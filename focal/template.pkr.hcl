variable "name" {
  type = string
  default = "focal64"
} 

variable "cpus" {
  type = string
  default = "2"
} 

variable "memory" {
  type = string
  default = "1024"
} 

variable "disk_size" {
  type = string
  default = "204800"
} 

variable "iso_checksum" {
  type = string
  default = "36f15879bd9dfd061cd588620a164a82972663fdd148cce1f70d57d314c21b73"
} 

variable "iso_checksum_type" {
  type = string
  default = "sha256"
}

variable "iso_url" {
  type = string
  default = "http://cdimage.ubuntu.com/ubuntu-legacy-server/releases/20.04/release/ubuntu-20.04-legacy-server-amd64.iso"
}

variable "ssh_username" {
  type    = string
  default = "vagrant"
}

variable "ssh_password" {
  type    = string
  default = "vagrant"
}

variable "box_tag" {
  type = string
  description = "box tag for vagrant cloud"
  default = "apopa/focal64"
}

variable "version" {
  type = string
  description = "box version for vagrant cloud"
  default = "0.0.1"
}

source "virtualbox-iso" "step_1" {
  boot_command = [
    "<esc><wait>",
    "<esc><wait>",
    "<enter><wait>",
    "/install/vmlinuz<wait>",
    " auto<wait>",
    " console-setup/ask_detect=false<wait>",
    " console-setup/layoutcode=us<wait>",
    " console-setup/modelcode=pc105<wait>",
    " debconf/frontend=noninteractive<wait>",
    " debian-installer=en_US<wait>",
    " fb=false<wait>",
    " initrd=/install/initrd.gz<wait>",
    " kbd-chooser/method=us<wait>",
    " keyboard-configuration/layout=USA<wait>",
    " keyboard-configuration/variant=USA<wait>",
    " locale=en_US<wait>",
    " netcfg/get_domain=vm<wait>",
    " netcfg/get_hostname=vagrant<wait>",
    " grub-installer/bootdev=/dev/sda<wait>",
    " noapic<wait>",
    " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<wait>",
    " -- <wait>",
    "<enter><wait>"
  ]
  boot_wait            = "5s"
  disk_size            = var.disk_size
  guest_additions_path = "VBoxGuestAdditions.iso"
  guest_os_type        = "Ubuntu_64"
  http_directory       = "http"
  iso_checksum         = var.iso_checksum
  iso_urls             = [var.iso_url]
  shutdown_command     = "echo '${var.ssh_password}' | sudo -S shutdown -P now"
  ssh_username         = var.ssh_username
  ssh_password         = var.ssh_password
  ssh_wait_timeout     = "10000s"
  vm_name              = "${var.name}-vbox"
  vboxmanage           = [
    [ 
      "modifyvm", "${var.name}-vbox",
      "--memory","${var.memory}"
    ],
    [
      "modifyvm", "${var.name}-vbox", 
      "--cpus","${var.cpus}"
    ]
  ]
}

build {
  sources = [
    "source.virtualbox-iso.step_1",
  ]
  
  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive"
    ]
    execute_command = "echo ${var.ssh_password} | {{.Vars}} sudo -E -S bash '{{.Path}}'"
    expect_disconnect = true
    scripts = [
      "scripts/packages.sh",
      "scripts/vagrant.sh",
      "scripts/virtualbox.sh",
      "scripts/cleanup.sh"
    ]
  }

  post-processor "manifest" {
    output = "stage-1-manifest.json"
  }

  post-processors {
    post-processor "vagrant" {
      output = "${var.name}.box"
    }
  }
}
