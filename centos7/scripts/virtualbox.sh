# Install the VirtualBox guest additions
VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
VBOX_ISO=VBoxGuestAdditions.iso
mount -o loop $VBOX_ISO /mnt
yes | sh /mnt/VBoxLinuxAdditions.run
umount /mnt

#Cleanup VirtualBox
#rm $VBOX_ISO

shutdown -r now
sleep 60