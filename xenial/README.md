# Ubuntu Xenial64

## Pre-requirements 
- [packer](https://www.packer.io/)
- [vagrant](https://www.vagrantup.com/)
- [kitchent-test](https://kitchen.ci/)
- [virtualbox](https://www.virtualbox.org/)

## How to use it
```bash
git clone git@github.com:andrewpopa/packer-boxes.git
cd packer-boxes/xenial
```
validate the packer template
```bash
packer validate template.pkr.hcl
```

build just for virtualbox
```bash
packer build -only=virtualbox-iso.virtualbox .
```

add the box to vagrant
```bash
vagrant box add --name xenial64 --provider virtualbox xenial64.box 
```

## Testing

configure ruby enviroment 

```ruby
rbenv install 2.6.3
rbenv local 2.6.3
rbenv versions
gem install bundler
bundle install
```

run the tests
```bash
bundle exec kitchen converge
bundle exec kitchen verify
bundle exec kitchen destroy
```

### Test results

once tests were executed successfully you'll get similar output
```bash
# ...
  ✔  operating_system: Command: `lsb_release -a`
     ✔  Command: `lsb_release -a` stdout is expected to match /Ubuntu/


Profile Summary: 1 successful control, 0 control failures, 0 controls skipped
Test Summary: 1 successful, 0 failures, 0 skipped
# ...
```

#### Publish to Vagrant Cloud

assuming that you are loggedin, you can publish the box to consume it from VagrandtCloud for local use.

for virtualbox
```bash
vagrant cloud publish apopa/xenial64 1.0.1 \
  virtualbox xenial64.box \
  -d "Xenial64 minimal" \
  --version-description "Xenial64 minimal" \
  --release --short-description "Xenial64 minimal" -f
```

for vmware fusion
```bash
vagrant cloud publish apopa/xenial64 1.0.1 \
  vmware_desktop xenial64_vmware.box \
  -d "Xenial64 minimal" \
  --version-description "Xenial64 minimal" \
  --release --short-description "Xenial64 minimal" -f
```