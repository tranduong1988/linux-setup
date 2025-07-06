#!/bin/bash

source utils.sh

sudo pacman -S --noconfirm --needed noto-fonts  
sudo pacman -S --noconfirm --needed noto-fonts-cjk 
sudo pacman -S --noconfirm --needed noto-fonts-emoji
sudo pacman -S --noconfirm --needed noto-fonts-extra

sudo pacman -S --noconfirm --needed git
sudo pacman -S --noconfirm --needed 7zip
sudo pacman -S --noconfirm --needed unrar
sudo pacman -S --noconfirm --needed unzip
sudo pacman -S --noconfirm --needed sysstat
sudo pacman -S --noconfirm --needed htop
sudo pacman -S --noconfirm --needed btop
sudo pacman -S --noconfirm --needed tlp
sudo pacman -S --noconfirm --needed vlc
sudo pacman -S --noconfirm --needed qbittorrent
sudo pacman -S --noconfirm --needed atril
sudo pacman -S --noconfirm --needed tk
sudo pacman -S --noconfirm --needed rsync
sudo pacman -S --noconfirm --needed fcitx5 fcitx5-configtool fcitx5-gtk fcitx5-qt fcitx5-bamboo
yes | sudo pacman -S --needed virt-manager qemu-desktop libvirt edk2-ovmf dnsmasq vde2 bridge-utils iptables-nft dmidecode
sudo pacman -S --noconfirm --needed docker
sudo pacman -S --noconfirm --needed nvm
sudo pacman -S --noconfirm --needed pyenv
sudo pacman -S --noconfirm --needed rofi
sudo pacman -S --noconfirm --needed texstudio
sudo pacman -S --noconfirm --needed xarchiver
sudo pacman -S --noconfirm --needed zram-generator
sudo pacman -S --noconfirm --needed xfce4-systemload-plugin
sudo pacman -S --noconfirm --needed reflector

# aur package
yay -S --mflags --skipinteg --noconfirm --needed visual-studio-code-bin
yay -S --mflags --skipinteg --noconfirm --needed google-chrome
yay -S --mflags --skipinteg --noconfirm --needed goenv
yay -S --mflags --skipinteg --noconfirm --needed starship

# pyenv, nvm, goenv, starship
# echo "Installing NVM..."
# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# echo "Installing goenv..."
# git clone https://github.com/go-nv/goenv.git ~/.goenv

# echo "Installing pyenv..."
# curl https://pyenv.run | bash

# echo "Installing starship..."
# curl -sS https://starship.rs/install.sh | sh

