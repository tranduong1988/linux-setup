#!/bin/bash

# set swapfile
sudo swapoff -a

sudo rm /swapfile

sudo fallocate -l 2G /swapfile

# sudo dd if=/dev/zero of=/swapfile bs=1M count=4096

sudo chmod 600 /swapfile

sudo mkswap /swapfile

sudo swapon /swapfile

sudo sh -c 'echo "" >> /etc/fstab'
sudo sh -c 'echo "/swapfile none swap sw 0 0" >> /etc/fstab'

sudo swapon --show

# end set swapfile

# set cache to ram
sudo sh -c 'echo "" >> /etc/fstab'
# sudo sh -c 'echo "tmpfs /tmp tmpfs defaults,noatime,size=1G 0 0" >> /etc/fstab'
# sudo sh -c 'echo "tmpfs /var/tmp tmpfs defaults,noatime,size=1G 0 0" >> /etc/fstab'
# sudo sh -c 'echo "tmpfs /var/log tmpfs defaults,noatime,size=500M 0 0" >> /etc/fstab'
sudo sh -c 'echo "tmpfs /home/'$USER'/.cache/google-chrome tmpfs defaults,noatime,size=512M 0 0" >> /etc/fstab'
sudo sh -c 'echo "tmpfs /home/'$USER'/.cache/microsoft-edge tmpfs defaults,noatime,size=512M 0 0" >> /etc/fstab'

sudo sh -c 'echo "tmpfs /home/'$USER'/.cache/yay tmpfs defaults,noatime,size=2G 0 0" >> /etc/fstab'
sudo sh -c 'echo "tmpfs /var/cache/pacman/pkg tmpfs defaults,noatime,size=2G 0 0" >> /etc/fstab'



# set vm.swappiness=10
sudo sh -c 'echo "" >> /etc/sysctl.conf'
sudo sh -c 'echo "vm.swappiness=10" >> /etc/sysctl.conf'
