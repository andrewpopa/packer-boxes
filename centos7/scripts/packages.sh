#!/bin/bash

yum -y install epel-release wget sudo bzip2 gcc make perl kernel-devel dkms
yum -y upgrade

cat >/etc/environment <<EOL
LANG=en_US.utf-8
LC_ALL=en_US.utf-8
EOL