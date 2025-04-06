#!/bin/bash

sudo apt install -y git
sudo apt install -y curl
sudo apt install -y 7zip
sudo apt install -y unrar
sudo apt install -y unzip
sudo apt install -y sysstat
sudo apt install -y htop
sudo apt install -y btop
sudo apt install -y tlp
sudo apt install -y vlc
sudo apt install -y qbittorrent
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager
sudo apt install -y qbittorrent
sudo apt install -y timeshift
sudo apt install -y inotify-tools
sudo apt install -y zram-tools
sudo apt install -y build-essential
sudo apt install -y fcitx5-bamboo
sudo apt install -y systemd-zram-generator 
sudo apt install -y --no-install-recommends texstudio



# aur package

# yay -S --noconfirm --needed timeshift-autosnap
# yay -S --noconfirm --needed ulauncher
# yay -S --noconfirm --needed visual-studio-code-bin
# yay -S --noconfirm --needed google-chrome

# pyenv, nvm, goenv, starship
echo "Installing NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

echo "Installing goenv..."
git clone https://github.com/go-nv/goenv.git ~/.goenv

echo "Installing pyenv..."
curl https://pyenv.run | bash

# Docker
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
echo "Install Docker...."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


# Cài đặt ulauncher
echo "Installing ulauncher... "
sudo apt update && sudo apt install -y gnupg
gpg --keyserver keyserver.ubuntu.com --recv 0xfaf1020699503176
gpg --export 0xfaf1020699503176 | sudo tee /usr/share/keyrings/ulauncher-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/ulauncher-archive-keyring.gpg] \
          http://ppa.launchpad.net/agornostal/ulauncher/ubuntu jammy main" \
          | sudo tee /etc/apt/sources.list.d/ulauncher-jammy.list
sudo apt update && sudo apt install -y ulauncher

git clone https://github.com/Antynea/grub-btrfs.git
cd grub-btrfs
sudo make install
cd ..

cd timeshift-autosnap
sudo make install
cd ..

echo "Installing starship..."
curl -sS https://starship.rs/install.sh | sh

