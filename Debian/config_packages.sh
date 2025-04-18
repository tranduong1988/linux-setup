#!/bin/bash

source utils.sh

# set key shortcut for rofi
xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/<Super>m" -t string -s "rofi -show drun -show-icons" --create

#config zram
add_text_to_file "zram-size = ram*0.5
compression-algorithm = zstd
swap-priority = 100
fs-type = swap" /etc/systemd/zram-generator.conf

# add env
# pyenv
add_text_to_file "
export PYENV_ROOT=\"\$HOME/.pyenv\"
[[ -d \$PYENV_ROOT/bin ]] && export PATH=\"\$PYENV_ROOT/bin:\$PATH\"
eval \"\$(pyenv init -)\"" ~/.bashrc

# goenv
add_text_to_file "
export GOENV_ROOT=\"\$HOME/.goenv\"
export PATH=\"\$GOENV_ROOT/bin:\$PATH\"
eval \"\$(goenv init -)\"" ~/.bashrc

# starship
add_text_to_file "
eval \"\$(starship init bash)\"" ~/.bashrc

# fcitx5
add_text_to_file "# fcitx5
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export INPUT_METHOD=fcitx
export Fcitx5_IM_BYPASS=1" /etc/profile

# edit file timeshift-autosnap config
# timeshift_autosnap_file='/etc/timeshift-autosnap.conf'
# find_and_replace "updateGrub=true" "updateGrub=false" $timeshift_autosnap_file
# find_and_replace "maxSnapshots=3" "maxSnapshots=5" $timeshift_autosnap_file

# edit file grub-btrfsd
sudo systemctl enable grub-btrfsd
sudo systemctl start grub-btrfsd
grub_btrfsd_file=$(sudo systemctl cat grub-btrfsd | head -n 1 | sed 's/^# //')
find_and_replace "--syslog /.snapshots" "--syslog --timeshift-auto" $grub_btrfsd_file
sudo systemctl restart grub-btrfsd

# KVM service
# sudo systemctl enable --now libvirtd.service
# sudo usermod -aG libvirt $USER
# sudo usermod -aG kvm $USER
# sudo virsh net-autostart default

# Enable services
DOCKER_IMAGES_PATH='/home/'$USER'/.local/share/docker/images'
mkdir -p $DOCKER_IMAGES_PATH
DAEMON_FILE='/etc/docker/daemon.json'
sudo mkdir -p '/etc/docker'
sudo touch $DAEMON_FILE

add_text_to_file "{
    \"data-root\": \"'$DOCKER_IMAGES_PATH'\"
}" $DAEMON_FILE

sudo systemctl enable --now docker.service
sudo systemctl start --now docker.service
sudo usermod -aG docker $USER
newgrp docker

