.PHONY: all validate virtualbox vmware aws azure gcp

all: validate virtualbox vmware aws azure gcp

validate:
	@echo "Validate packer template"
	packer fmt .
	packer validate .
virtualbox:
	@echo "Build virtualbox image"
	packer build -only=virtualbox-iso.virtualbox .
vmware:
	@echo "Build vmware fusion image"
	packer build -only=vmware-iso.vmware .
aws:
	@echo "Build AWS image AMI"
	packer build -only=amazon-ebs.aws .
azure:
	@echo "Build Azure image"
	packer build -only=azure-arm.azure .
gcp:
	@echo "Build GCP image"
	packer build -only=googlecompute.gcp .