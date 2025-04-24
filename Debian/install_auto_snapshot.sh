#!/bin/bash

source utils.sh

sudo apt install -y timeshift
sudo apt install -y inotify-tools

grub-btrfs
git clone https://github.com/Antynea/grub-btrfs.git
cd grub-btrfs
sudo make install
cd ..

cd timeshift-autosnap
sudo make install
cd ..

# edit file timeshift-autosnap config
timeshift_autosnap_file='/etc/timeshift-autosnap.conf'
find_and_replace "updateGrub=true" "updateGrub=false" $timeshift_autosnap_file
find_and_replace "maxSnapshots=3" "maxSnapshots=5" $timeshift_autosnap_file

# edit file grub-btrfsd
sudo systemctl enable grub-btrfsd
sudo systemctl start grub-btrfsd
grub_btrfsd_file=$(sudo systemctl cat grub-btrfsd | head -n 1 | sed 's/^# //')
find_and_replace "--syslog /.snapshots" "--syslog --timeshift-auto" $grub_btrfsd_file
sudo systemctl restart grub-btrfsd