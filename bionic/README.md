# Ubuntu Bionic64

## Pre-requirements 
- [packer](https://www.packer.io/)
- [vagrant](https://www.vagrantup.com/)
- [kitchent-test](https://kitchen.ci/)
- [virtualbox](https://www.virtualbox.org/)
- [vmware fusion](https://www.vmware.com/nl/products/fusion.html)

## How to use it manually
```bash
git clone git@github.com:andrewpopa/packer-boxes.git
cd packer-boxes/bionic
```
validate the packer template
```bash
packer validate .
```

build packer box
```bash
packer build .
```

## Testing

configure ruby enviroment 

```ruby
rbenv install 3.0.1


rbenv install 2.3.1
rbenv local 2.3.1
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

```bash
vagrant cloud publish apopa/bionic64 1.0.1 vmware_desktop bionic64_1.0.1_vmware.box -d "Bionic64 minimal" --version-description "Bionic64 minimal" --release --short-description "Bionic64 minimal" --force
```

## AWS

## Azure

To create virtual machine images there are some pre-requirements

you should be logged in

```bash
az login
```

Create Azure resource group

```bash
az group create -n myResourceGroup -l eastus
```

Create Azure credentials

```bash
az ad sp create-for-rbac --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"
```

with similar output

```bash
{
    "client_id": "f5b6a5cf-fbdf-4a9f-b3b8-3c2cd00225a4",
    "client_secret": "0e760437-bf34-4aad-9f8d-870be799c55d",
    "tenant_id": "72f988bf-86f1-41af-91ab-2d7cd011db47"
}
```

get Azure subscription ID

```bash
az account show --query "{ subscription_id: id }"
```

use the output of these commands as input for your packer templates

## GCP

get GCO source images list

```bash
gcloud compute images list --project <project-id-name>
```