#!/bin/bash

source utils.sh

# set key shortcut for rofi
xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/<Super>m" -t string -s "rofi -show drun -show-icons" --create

# add env

# # pyenv
# add_text_to_file "
# export PYENV_ROOT=\"\$HOME/.pyenv\"
# [[ -d \$PYENV_ROOT/bin ]] && export PATH=\"\$PYENV_ROOT/bin:\$PATH\"
# eval \"\$(pyenv init -)\"" ~/.bashrc
add_text_to_file "
eval \"\$(pyenv init -)\"" ~/.bashrc

# # goenv
# add_text_to_file "
# export GOENV_ROOT=\"\$HOME/.goenv\"
# export PATH=\"\$GOENV_ROOT/bin:\$PATH\"
# eval \"\$(goenv init -)\"" ~/.bashrc
add_text_to_file "
eval \"\$(goenv init -)\"" ~/.bashrc

# nvm 
add_text_to_file "
[ -z \"$NVM_DIR\" ] && export NVM_DIR=\"\$HOME/.nvm\"
source /usr/share/nvm/nvm.sh
source /usr/share/nvm/bash_completion" ~/.bashrc

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


# KVM service
# sudo systemctl enable --now libvirtd.service
# sudo usermod -aG libvirt $USER
# sudo usermod -aG kvm $USER
# sudo virsh net-autostart default

# Enable services
DOCKER_IMAGES_PATH='/home/var/lib/docker'
sudo mkdir -p $DOCKER_IMAGES_PATH
DAEMON_FILE='/etc/docker/daemon.json'
sudo mkdir -p '/etc/docker'
sudo touch $DAEMON_FILE

add_text_to_file "{
    \"data-root\": \"$DOCKER_IMAGES_PATH\"
}" $DAEMON_FILE

sudo systemctl enable --now docker.service
sudo systemctl start --now docker.service
sudo usermod -aG docker $USER
newgrp docker

