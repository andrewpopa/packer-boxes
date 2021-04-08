variable "name" {
  type    = string
  default = "bionic64"
}

variable "cpus" {
  type    = string
  default = "2"
}

variable "memory" {
  type    = string
  default = "1024"
}

variable "disk_size" {
  type    = string
  default = "204800"
}

variable "iso_checksum" {
  type    = string
  default = "8c5fc24894394035402f66f3824beb7234b757dd2b5531379cb310cedfdf0996"
}

variable "iso_checksum_type" {
  type    = string
  default = "sha256"
}

variable "iso_url" {
  type    = string
  default = "http://cdimage.ubuntu.com/ubuntu/releases/18.04/release/ubuntu-18.04.5-server-amd64.iso"
}

variable "ssh_username" {
  type    = string
  default = "vagrant"
}

variable "ssh_password" {
  type    = string
  default = "vagrant"
}

variable "version" {
  type    = string
  default = "1.0.1"
}

locals {
  standard_tags = {
    Release     = "Bionic"
    Environment = "production"
  }
}

// AWS
variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "ami_description" {
  type    = string
  default = "aws ami instance bionic"
}

variable "source_ami" {
  type        = string
  default     = "ami-0e0102e3ff768559b"
  description = "Ubuntu Server 18.04 LTS (HVM), SSD Volume Type"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

// Azure
variable "client_id" {
  type    = string
  default = "<client_id>"
}

variable "client_secret" {
  type    = string
  default = "<client_secret>"
}

variable "tenant_id" {
  type    = string
  default = "<tenant_id>"
}

variable "subscription_id" {
  type    = string
  default = "<subscription_id>"
}

variable "managed_image_resource_group_name" {
  type    = string
  default = "apopa"
}

variable "capture_name_prefix" {
  type    = string
  default = "packer"
}

variable "os_type" {
  type    = string
  default = "Linux"
}

variable "image_publisher" {
  type    = string
  default = "Canonical"
}

variable "image_offer" {
  type    = string
  default = "UbuntuServer"
}

variable "image_sku" {
  type    = string
  default = "18.04-LTS"
}

variable "location" {
  type        = string
  default     = "West Europe"
  description = "Region location"
}

variable "vm_size" {
  type        = string
  default     = "Standard_A2"
  description = "Virtualmachine size"
}


// gcp
variable "project_id" {
  type        = string
  default     = "<project-id>"
  description = "GCP project ID"
}