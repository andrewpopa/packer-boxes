// virtualbox
source "virtualbox-iso" "virtualbox" {
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
  vboxmanage = [
    [
      "modifyvm", "${var.name}-vbox",
      "--memory", "${var.memory}"
    ],
    [
      "modifyvm", "${var.name}-vbox",
      "--cpus", "${var.cpus}"
    ]
  ]
}

// vmware fusion
source "vmware-iso" "vmware" {
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
  boot_wait        = "5s"
  disk_size        = var.disk_size
  guest_os_type    = "ubuntu64Guest"
  http_directory   = "http"
  iso_checksum     = var.iso_checksum
  iso_urls         = [var.iso_url]
  shutdown_command = "echo '${var.ssh_password}' | sudo -S shutdown -P now"
  ssh_username     = var.ssh_username
  ssh_password     = var.ssh_password
  ssh_wait_timeout = "10000s"
  vm_name          = "${var.name}-vbox"
}

// aws
source "amazon-ebs" "aws" {
  ami_name        = "${var.name}-${var.version}"
  ami_description = var.ami_description
  instance_type   = var.instance_type
  launch_block_device_mappings {
    delete_on_termination = true
    device_name           = "/dev/sda1"
    volume_size           = 50
    volume_type           = "gp2"
  }
  region       = var.region
  source_ami   = var.source_ami
  ssh_username = "ubuntu"

  dynamic "tag" {
    for_each = local.standard_tags
    content {
      key   = tag.key
      value = tag.value
    }
  }
}

// azure
// TODO: dynamic tags
source "azure-arm" "azure" {
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id

  managed_image_resource_group_name = var.managed_image_resource_group_name
  managed_image_name                = "${var.name}-${var.version}"
  os_type                           = var.os_type
  image_publisher                   = var.image_publisher
  image_offer                       = var.image_offer
  image_sku                         = var.image_sku
  location                          = var.location
  vm_size                           = var.vm_size

  azure_tags = {
    Release     = "Bionic"
    Environment = "production"
  }
}

// gcp
source "googlecompute" "gcp" {
  project_id          = var.project_id
  image_name          = "${var.name}"
  image_description   = "${var.name}-${var.version}"
  source_image_family = "${var.name}"
  disk_size           = "50"
  disk_type           = "pd-ssd"
  machine_type        = "n1-standard-1"
  source_image        = "ubuntu-1804-bionic-v20210325"
  zone                = "europe-west4-a"
  ssh_username        = "root"

  image_labels = {
    release     = "bionic"
    environment = "production"
  }
}

build {
  sources = [
    "source.virtualbox-iso.virtualbox",
    "source.vmware-iso.vmware",
    "source.amazon-ebs.aws",
    "source.azure-arm.azure",
    "source.googlecompute.gcp",
  ]

  // virtualbox
  provisioner "shell" {
    only = ["virtualbox-iso.virtualbox"]
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive"
    ]
    execute_command   = "echo ${var.ssh_password} | {{.Vars}} sudo -E -S bash '{{.Path}}'"
    expect_disconnect = true
    scripts = [
      "scripts/packages.sh",
      "scripts/vagrant.sh",
      "scripts/virtualbox.sh",
      "scripts/cleanup.sh"
    ]
  }

  // vmware fusion
  provisioner "shell" {
    only = ["vmware-iso.vmware"]
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive"
    ]
    execute_command   = "echo ${var.ssh_password} | {{.Vars}} sudo -E -S bash '{{.Path}}'"
    expect_disconnect = true
    scripts = [
      "scripts/packages.sh",
      "scripts/vagrant.sh",
      "scripts/vmware.sh",
      "scripts/cleanup.sh"
    ]
  }

  // aws
  provisioner "shell" {
    only              = ["amazon-ebs.aws"]
    environment_vars  = ["DEBIAN_FRONTEND=noninteractive"]
    expect_disconnect = true
    scripts = [
      "scripts/packages.sh",
    ]
  }

  // azure
  provisioner "shell" {
    only              = ["azure-arm.azure"]
    environment_vars  = ["DEBIAN_FRONTEND=noninteractive"]
    expect_disconnect = true
    scripts = [
      "scripts/packages.sh",
    ]
  }

  // gcp
  provisioner "shell" {
    only              = ["googlecompute.gcp"]
    environment_vars  = ["DEBIAN_FRONTEND=noninteractive"]
    expect_disconnect = true
    scripts = [
      "scripts/packages.sh",
    ]
  }

  post-processor "manifest" {
    output = "stage-1-manifest.json"
  }

  post-processor "vagrant" {
    only   = ["virtualbox-iso.virtualbox"]
    output = "${var.name}_${var.version}.box"
  }

  post-processor "vagrant" {
    only   = ["vmware-iso.vmware"]
    output = "${var.name}_${var.version}_vmware.box"
  }
}
