variable "build_name" {
  default = "xenial64"
}

source "virtualbox-iso" "step_1" {
  boot_command     = ["<enter><f6><esc><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
                      "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
                      "debian-installer=en_US auto locale=en_US kbd-chooser/method=us ",
                      "hostname=${var.build_name} ",
                      "fb=false debconf/fronten=d=noninteractive ",
                      "keyboard-configuration/modelcode=SKIP keyboard-configuration/layout=USA keyboard-configuration/variant=USA console-setup/ask_detect=false ",
                      "initrd=/install/initrd.gz -- <enter>"]
  disk_size        = "40960"
  guest_os_type    = "Ubuntu_64"
  http_directory   = "./http"
  iso_checksum     = "sha256:b23488689e16cad7a269eb2d3a3bf725d3457ee6b0868e00c8762d3816e25848"
  iso_url          = "https://releases.ubuntu.com/xenial/ubuntu-16.04.7-server-amd64.iso"
  shutdown_command = "echo 'vagrant' | sudo -S shutdown -P now"
  ssh_password     = "vagrant"
  ssh_port         = 22
  ssh_username     = "vagrant"
  vm_name          = "xenial64"
  ssh_timeout	   = "40m"
}

build {
  sources = ["source.virtualbox-iso.step_1"]
  provisioner "shell" {
    inline = ["echo initial provisioning"]
  }
  post-processor "manifest" {
    output = "stage-1-manifest.json"
  }
}
