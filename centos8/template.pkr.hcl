variable "name" {
  type = string
  default = "centos8"
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
  default = "47ab14778c823acae2ee6d365d76a9aed3f95bb8d0add23a06536b58bb5293c0"
} 

variable "iso_checksum_type" {
  type = string
  default = "sha256"
}

variable "iso_url" {
  type = string
  default = "http://mirror.wd6.net/centos/8.2.2004/isos/x86_64/CentOS-8.2.2004-x86_64-minimal.iso"
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
  default = "apopa/centos8"
}

variable "version" {
  type = string
  description = "box version for vagrant cloud"
  default = "0.0.1"
}

source "virtualbox-iso" "step_1" {
  boot_command = [
    "<tab> text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter><wait>"
  ]
  boot_wait            = "5s"
  disk_size            = var.disk_size
  guest_additions_path = "VBoxGuestAdditions.iso"
  guest_os_type        = "RedHat_64"
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
