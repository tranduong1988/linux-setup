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
eval \"\$(pyenv init -)\"" ~/.bashrc

# goenv
echo "config goenv..."
add_text_to_file "
eval \"\$(goenv init -)\"" ~/.bashrc

# nvm 
echo "config nvm..."
add_text_to_file "
[ -z \"$NVM_DIR\" ] && export NVM_DIR=\"\$HOME/.nvm\"
source /usr/share/nvm/nvm.sh
source /usr/share/nvm/bash_completion" ~/.bashrc

# starship
echo "config starship..."
add_text_to_file "
eval \"\$(starship init bash)\"" ~/.bashrc
starship preset tokyo-night -o ~/.config/starship.toml

# rofi
echo "config rofi..."
xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/<Super>m" -t string -s "rofi -show drun -show-icons" --create
mkdir ~/.config/rofi
curl https://raw.githubusercontent.com/dracula/rofi/master/theme/config1.rasi -o ~/.config/rofi/config.rasi


echo "config theme and terminal..."
xfconf-query -c xsettings -p /Net/ThemeName -s "Orchis-Dark-Compact" --create -t string
xfconf-query -c xsettings -p /Net/IconThemeName -s "Qogir-dark" --create -t string
xfconf-query -c xfwm4 -p /general/theme -s "Orchis-Dark-Compact" --create -t string

xfconf-query -c xsettings -p /Gtk/FontName -s "Inter Display Regular 10" --create -t string
xfconf-query -c xfwm4 -p /general/title_font -s "Inter Display Bold 9" --create -t string

xfconf-query -c xfce4-terminal -p /font-name -s "0xProto Nerd Font Mono Regular 11" --create -t string
xfconf-query -c xfce4-terminal -p /misc-menubar-default -s false --create -t bool
xfconf-query -c xfce4-terminal -p /background-mode -s "TERMINAL_BACKGROUND_TRANSPARENT" --create -t string
xfconf-query -c xfce4-terminal -p /background-darkness -s 0.75 --create -t double
xfconf-query -c xfce4-terminal -p /misc-default-geometry -s "120x30" --create -t string

# cp xfce4-panel.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/
rename_launchers_safely 16
CONFIG_DIR="$HOME/.config/xfce4/panel"

mapfile -t file < <(find "$CONFIG_DIR/launcher-16" -maxdepth 1 -type f -name "*" | sort)
dir=$(dirname "$file")
mv "$file" "$dir/terminal.desktop"

mapfile -t file < <(find "$CONFIG_DIR/launcher-17" -maxdepth 1 -type f -name "*" | sort)
dir=$(dirname "$file")
mv "$file" "$dir/filemanager.desktop"

mapfile -t file < <(find "$CONFIG_DIR/launcher-18" -maxdepth 1 -type f -name "*" | sort)
dir=$(dirname "$file")
mv "$file" "$dir/browser.desktop"

mapfile -t file < <(find "$CONFIG_DIR/launcher-19" -maxdepth 1 -type f -name "*" | sort)
dir=$(dirname "$file")
mv "$file" "$dir/appfind.desktop"