#!/bin/bash

yum -y install \
    epel-release \
    wget \
    sudo \
    bzip2 \
    gcc \
    make \
    perl \
    kernel-devel \
    elfutils-libelf-devel \
    tar
yum -y upgrade