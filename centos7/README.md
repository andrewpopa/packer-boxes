# CentOS 7

## Pre-requirements 
- [packer](https://www.packer.io/)
- [vagrant](https://www.vagrantup.com/)
- [virtualbox](https://www.virtualbox.org/)

## How to use it
```bash
git clone git@github.com:andrewpopa/packer-boxes.git
cd packer-boxes/centos7
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
vagrant box add --name centos7 --provider virtualbox centos7.box 
```

### Publish to Vagrant Cloud

create authentication [token](https://app.vagrantup.com/settings/security) for vagrant cloud

use as environment variable 

```bash
export VAGRANT_CLOUD_TOKEN=<VAGRANT_TOKEN>
```

make sure you are logged in

```bash
vagrant cloud auth login
```

once you are logged in you can publish the box to consume it from Vagrant Cloud

```bash
vagrant cloud publish apopa/centos7 1.0.0 virtualbox centos7.box -d "centos7 minimal" --version-description "centos7 minimal" --release --short-description "centos7 minimal"
```
