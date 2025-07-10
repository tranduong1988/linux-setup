#!/bin/bash

source utils.sh

#config zram
echo "config zram-generator..."
sudo touch /etc/systemd/zram-generator.conf
add_text_to_file "[zram0]
zram-size = ram*0.5
compression-algorithm = zstd
swap-priority = 100
fs-type = swap" /etc/systemd/zram-generator.conf

sudo systemctl daemon-reexec
sudo systemctl start systemd-zram-setup@zram0.service

# KVM service
# sudo systemctl enable --now libvirtd.service
# sudo usermod -aG libvirt $USER
# sudo usermod -aG kvm $USER
# sudo virsh net-autostart default

# Enable services
echo "config docker..."

# DOCKER_IMAGES_PATH='/home/var/lib/docker'
# sudo mkdir -p $DOCKER_IMAGES_PATH
# DAEMON_FILE='/etc/docker/daemon.json'
# sudo mkdir -p '/etc/docker'
# sudo touch $DAEMON_FILE

# add_text_to_file "{
#     \"data-root\": \"$DOCKER_IMAGES_PATH\"
# }" $DAEMON_FILE

sudo systemctl enable --now docker.service
sudo systemctl start --now docker.service
sudo usermod -aG docker $USER
# newgrp docker

# fcitx5
echo "config fcitx5 bamboo..."
add_text_to_file "# fcitx5
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export INPUT_METHOD=fcitx
export Fcitx5_IM_BYPASS=1" /etc/profile


# local user
# Copy home directory contents
echo "Copying home directory contents..."
if [ -d "./home/username/" ]; then
    cp -rf ./home/username/. ~/
    echo "Home directory copied successfully."
else
    echo "./home/username/ not found. Skipping home directory copy."
fi

# pyenv
echo "config pyenv..."
add_text_to_file "
export PYENV_ROOT=\"\$HOME/.pyenv\"
[[ -d \$PYENV_ROOT/bin ]] && export PATH=\"\$PYENV_ROOT/bin:\$PATH\"
eval \"\$(pyenv init -)\"" ~/.bashrc

# goenv
echo "config goenv..."
add_text_to_file "
export GOENV_ROOT=\"\$HOME/.goenv\"
export PATH=\"\$GOENV_ROOT/bin:\$PATH\"
eval \"\$(goenv init -)\"" ~/.bashrc

# starship
echo "config starship..."
add_text_to_file "
eval \"\$(starship init bash)\"" ~/.bashrc
# starship preset tokyo-night -o ~/.config/starship.toml

# rofi
echo "config rofi..."
xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/<Super>m" -t string -s "rofi -show drun -show-icons" --create
# mkdir ~/.config/rofi
# curl https://raw.githubusercontent.com/dracula/rofi/master/theme/config1.rasi -o ~/.config/rofi/config.rasi




