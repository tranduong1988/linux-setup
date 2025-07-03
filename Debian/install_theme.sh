#!/bin/bash

mkdir -p Qogir-icon
curl -L https://github.com/vinceliuice/Qogir-icon-theme/archive/refs/tags/2025-02-15.tar.gz | tar -xzf - -C Qogir-icon --strip-components=1
cd Qogir-icon
./install.sh
cd ..

mkdir -p Orchis-theme
curl -L https://github.com/vinceliuice/Orchis-theme/archive/refs/tags/2024-11-03.tar.gz  | tar -xzf - -C Orchis-theme --strip-components=1
cd Orchis-theme
./install.sh
cd ..


mkdir -p ~/.local/share/fonts
curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/0xProto.tar.xz | tar -xJf - -C ~/.local/share/fonts

curl -L https://github.com/rsms/inter/releases/download/v4.1/Inter-4.1.zip -o /tmp/Inter-4.1.zip
unzip -j /tmp/Inter-4.1.zip "Inter.ttc" "InterVariable.ttf" "InterVariable-Italic.ttf" -d ~/.local/share/fonts
fc-cache -fv


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
