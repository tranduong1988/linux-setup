#!/bin/bash

source utils.sh

mkdir -p $HOME/.cache/$commandyay

sudo mount -t tmpfs -o size=2G tmpfs /var/cache/pacman/pkg
sudo mount -t tmpfs -o size=2G tmpfs $HOME/.cache/$commandyay

# ./set_config.sh
./install_theme.sh
./install_packages.sh
./config_packages.sh
./install_auto_snapshot.sh