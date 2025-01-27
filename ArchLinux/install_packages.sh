#!/bin/bash

source utils.sh
# edit pacman.conf
find_and_replace "#ParallelDownloads" "ParallelDownloads" /etc/pacman.conf


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
yay -S --noconfirm --needed timeshift-autosnap
yay -S --noconfirm --needed ulauncher
yay -S --noconfirm --needed visual-studio-code-bin
yay -S --noconfirm --needed google-chrome

# pyenv, nvm, goenv, starship
echo "Installing NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

echo "Installing goenv..."
git clone https://github.com/go-nv/goenv.git ~/.goenv

echo "Installing pyenv..."
curl https://pyenv.run | bash

echo "Installing starship..."
curl -sS https://starship.rs/install.sh | sh

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

# KVM service
sudo systemctl enable --now libvirtd.service
sudo usermod -aG libvirt $USER
sudo usermod -aG kvm $USER
sudo virsh net-autostart default

# edit file grub-btrfsd
grub_btrfsd_file=$(sudo systemctl cat grub-btrfsd | head -n 1 | sed 's/^# //')
find_and_replace "--syslog /.snapshots" "--syslog --timeshift-auto" $grub_btrfsd_file

sudo systemctl enable grub-btrfsd
sudo systemctl start grub-btrfsd

