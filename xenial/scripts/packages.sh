#!/bin/bash
export DEBIAN_FRONTEND="noninteractive"

apt-get clean
apt-get update
apt-get upgrade -y

# Update to the latest kernel
apt-get install -y linux-generic linux-image-generic

shutdown -r now
sleep 60