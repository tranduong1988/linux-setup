#!/bin/bash

source utils.sh

sudo pacman -S --noconfirm inter-font
sudo pacman -S --noconfirm ttf-0xproto-nerd 

yay -S --noconfirm qogir-icon-theme
# yay -S --noconfirm materia-gtk-theme
yay -S --noconfirm orchis-theme

xfconf-query -c xsettings -p /Net/ThemeName -s "Orchis-Dark-Compact"
xfconf-query -c xsettings -p /Net/IconThemeName -s "Qogir-dark"
xfconf-query -c xfwm4 -p /general/theme -s "Orchis-Dark-Compact"

xfconf-query -c xsettings -p /Gtk/FontName -s "Inter Display Regular 10"
xfconf-query -c xfwm4 -p /general/title_font -s "Inter Display Bold 9"
xfconf-query -c xfce4-terminal -p /font-name -s "0xProto Nerd Font Regular 12"
