# Ubuntu CentOS8

## Pre-requirements 
- [packer](https://www.packer.io/)
- [vagrant](https://www.vagrantup.com/)
- [virtualbox](https://www.virtualbox.org/)

## How to use it
```bash
git clone git@github.com:andrewpopa/packer-boxes.git
cd packer-boxes/centos8
```
validate the packer template
```bash
packer validate template.pkr.hcl
```

build packer box
```bash
packer build template.pkr.hcl
```

add the box to vagrant
```bash
vagrant box add --name centos8 --provider virtualbox centos8.box 
```

## Publish to Vagrant Cloud

assuming that you are loggedin, you can publish the box to consume it from VagrandtCloud for local use.

```bash
vagrant cloud publish apopa/centos8 1.0.0 virtualbox centos8.box -d "CentOS8 minimal" --version-description "CentOS8 minimal" --release --short-description "CentOS8 minimal"
```
