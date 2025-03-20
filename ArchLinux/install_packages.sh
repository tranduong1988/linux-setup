#!/bin/bash

sudo pacman -S --noconfirm noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra
sudo pacman -S --noconfirm git
sudo pacman -S --noconfirm 7zip
sudo pacman -S --noconfirm unrar
sudo pacman -S --noconfirm unzip
sudo pacman -S --noconfirm sysstat
sudo pacman -S --noconfirm htop
sudo pacman -S --noconfirm btop
sudo pacman -S --noconfirm tlp
sudo pacman -S --noconfirm vlc
sudo pacman -S --noconfirm qbittorrent
sudo pacman -S --noconfirm okular
sudo pacman -S --noconfirm tk
sudo pacman -S --noconfirm fcitx5 fcitx5-configtool fcitx5-gtk fcitx5-qt fcitx5-bamboo
sudo pacman -S --noconfirm virt-manager qemu-desktop libvirt edk2-ovmf dnsmasq vde2 bridge-utils iptables-nft dmidecode
sudo pacman -S --noconfirm docker
sudo pacman -S --noconfirm timeshift
sudo pacman -S --noconfirm grub-btrfs 
sudo pacman -S --noconfirm inotify-tools

# aur package
paru -S --noconfirm --needed timeshift-autosnap
paru -S --noconfirm --needed ulauncher
paru -S --noconfirm --needed visual-studio-code-bin
paru -S --noconfirm --needed google-chrome

# pyenv, nvm, goenv, starship
echo "Installing NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

echo "Installing goenv..."
git clone https://github.com/go-nv/goenv.git ~/.goenv

echo "Installing pyenv..."
curl https://pyenv.run | bash

echo "Installing starship..."
curl -sS https://starship.rs/install.sh | sh

