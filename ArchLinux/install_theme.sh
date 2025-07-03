#!/bin/bash

source utils.sh

sudo pacman -S --noconfirm inter-font
sudo pacman -S --noconfirm ttf-0xproto-nerd 

yay -S --noconfirm qogir-icon-theme
# yay -S --noconfirm materia-gtk-theme
yay -S --noconfirm orchis-theme

xfconf-query -c xsettings -p /Net/ThemeName -s "Orchis-Dark-Compact" --create -t string
xfconf-query -c xsettings -p /Net/IconThemeName -s "Qogir-dark" --create -t string
xfconf-query -c xfwm4 -p /general/theme -s "Orchis-Dark-Compact" --create -t string

xfconf-query -c xsettings -p /Gtk/FontName -s "Inter Display Regular 10" --create -t string
xfconf-query -c xfwm4 -p /general/title_font -s "Inter Display Bold 9" --create -t string

xfconf-query -c xfce4-terminal -p /font-name -s "0xProto Nerd Font Regular 12" --create -t string
xfconf-query -c xfce4-terminal -p /misc-menubar-default -s false --create -t bool
xfconf-query -c xfce4-terminal -p /background-mode -s "TERMINAL_BACKGROUND_TRANSPARENT" --create -t string
xfconf-query -c xfce4-terminal -p /background-darkness -s 0.75 --create -t double
xfconf-query -c xfce4-terminal -p /misc-default-geometry -s "120x30" --create -t string

cp xfce4-panel.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/
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
