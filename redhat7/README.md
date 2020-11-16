# Ubuntu RedHat7

## Pre-requirements 
- [packer](https://www.packer.io/)
- [vagrant](https://www.vagrantup.com/)
- [virtualbox](https://www.virtualbox.org/)

## How to use it
```bash
git clone git@github.com:andrewpopa/packer-boxes.git
cd packer-boxes/redhat7
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
vagrant box add --name redhat7 --provider virtualbox redhat7.box 
```

## Publish to Vagrant Cloud

assuming that you are loggedin, you can publish the box to consume it from VagrandtCloud for local use.

```bash
vagrant cloud publish apopa/redhat7 1.0.0 virtualbox redhat7.box -d "RedHat7 minimal" --version-description "RedHat7 minimal" --release --short-description "RedHat7 minimal"
```
