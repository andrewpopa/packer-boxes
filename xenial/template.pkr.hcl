variable "cpus" {
  type = string
  default = "2"
} 

variable "disk_size" {
  type = string
  default = "40960"
} 

variable "hostname" {
  type = string
  default = "xenial64"
} 

variable "iso_checksum" {
  type = string
  default = "b23488689e16cad7a269eb2d3a3bf725d3457ee6b0868e00c8762d3816e25848"
} 

variable "iso_checksum_type" {
  type = string
  default = "sha256"
} 

variable "iso_url" {
  type = string
  default = "https://releases.ubuntu.com/xenial/ubuntu-16.04.7-server-amd64.iso"
}

variable "memory" {
  type = string
  default = "1024"
} 

variable "preseed" {
  type    = string
  default = "preseed.cfg"
}

variable "ssh_fullname" {
  type    = string
  default = "vagrant"
}

variable "ssh_password" {
  type    = string
  default = "vagrant"
}

variable "ssh_username" {
  type    = string
  default = "vagrant"
}

variable "version" {
  type    = string
  default = "0.1"
}

variable "virtualbox_guest_os_type" {
  type    = string
  default = "Ubuntu_64"
}

variable "vm_name" {
  type    = string
  default = "xenial64"
}

# AWS
variable "region" {
  type    = string
  default = "eu-central-1"
}

source "virtualbox-iso" "step_1" {
  boot_command = [
    "<enter><f6><esc><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
    "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.preseed} ",
    "debian-installer=en_US ",
    "auto locale=en_US kbd-chooser/method=us ",
    "hostname=${var.hostname} ",
    "fb=false debconf/frontend=noninteractive ",
    "keyboard-configuration/modelcode=SKIP ",
    "keyboard-configuration/layout=USA ",
    "keyboard-configuration/variant=USA ",
    "console-setup/ask_detect=false ",
    "initrd=/install/initrd.gz -- <enter>"
    ]
  disk_size            = var.disk_size
  guest_additions_path = "VBoxGuestAdditions.iso"
  vm_name              = "${var.vm_name}-vbox"
  guest_os_type        = var.virtualbox_guest_os_type
  hard_drive_interface = "sata"
  http_directory       = "./http"
  iso_checksum         = "${var.iso_checksum_type}:${var.iso_checksum}"
  iso_urls             = [var.iso_url]
  output_directory     = "output"
  shutdown_command     = "echo '${var.ssh_password}' | sudo -S shutdown -P now"
  ssh_username         = var.ssh_username
  ssh_password         = var.ssh_password
  ssh_wait_timeout     = "10000s"
  vboxmanage           = [[ "modifyvm", "${var.vm_name}-vbox","--memory","${var.memory}"],["modifyvm", "${var.vm_name}-vbox", "--cpus","${var.cpus}"]]
}


source "amazon-ebs" "step_2" {
  region = var.region
  source_ami = "ami-0668176b7d648cc1c"
  ami_name =  "xenial64-min"
  instance_type = "t2.micro"
  ssh_username = "ubuntu"
}


build {
  sources = [
    "source.virtualbox-iso.step_1",
    "source.amazon-ebs.step_2",
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

  post-processor "vagrant" {
    output = "${var.vm_name}.box"
  }
}
