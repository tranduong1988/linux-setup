#!/bin/bash

source utils.sh

# Install AUR helper if not found
AUR_HELPER=$(get_aur_helper)

$AUR_HELPER -S --mflags --skipinteg --noconfirm --needed qogir-icon-theme orchis-theme

xfconf-query -c xsettings -p /Net/ThemeName -s "Orchis-Dark-Compact" --create -t string
xfconf-query -c xsettings -p /Net/IconThemeName -s "Qogir-dark" --create -t string
xfconf-query -c xfwm4 -p /general/theme -s "Orchis-Dark-Compact" --create -t string