#!/bin/bash

source utils.sh

# Install AUR helper if not found
AUR_HELPER=$(get_aur_helper)

$AUR_HELPER -S --mflags --skipinteg --noconfirm --needed papirus-icon-theme matcha-gtk-theme

xfconf-query -c xsettings -p /Net/ThemeName -s "Matcha-dark-sea" --create -t string
xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus-Dark" --create -t string
xfconf-query -c xfwm4 -p /general/theme -s "Matcha-dark-sea" --create -t string