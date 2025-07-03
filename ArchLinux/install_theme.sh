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

# cp xfce4-panel.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/

# edit panel 2
clone_plugin 18 21 2
clone_plugin 17 20 2
clone_plugin 16 19 2
clone_plugin 15 18 2
clone_plugin 14 17 2
clone_plugin 13 16 2
clone_plugin 12 15 2
clone_plugin 11 14 2

#edit panel 1
xfconf-query -c xfce4-panel -p /panels/panel-1/plugin-ids -r
for i in {1..13}; do
    xfconf-query -c xfce4-panel -p /panels/panel-1/plugin-ids -n -t int -s "$i"
done

xfconf-query -c xfce4-panel -p /plugins/plugin-1 -s "applicationsmenu" --create -t string

xfconf-query -c xfce4-panel -p /plugins/plugin-2 -s "tasklist" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-2/grouping -s 1 --create -t uint

xfconf-query -c xfce4-panel -p /plugins/plugin-3 -s "separator" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-3/expand -s true --create -t bool
xfconf-query -c xfce4-panel -p /plugins/plugin-3/style -s 0 --create -t uint

xfconf-query -c xfce4-panel -p /plugins/plugin-4 -s "pager" --create -t string

xfconf-query -c xfce4-panel -p /plugins/plugin-5 -s "separator" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-5/style -s 0 --create -t uint

xfconf-query -c xfce4-panel -p /plugins/plugin-6 -s "systray" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-6/square-icons -s true --create -t bool

xfconf-query -c xfce4-panel -p /plugins/plugin-7 -s "pulseaudio" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-7/enable-keyboard-shortcuts -s true --create -t bool

xfconf-query -c xfce4-panel -p /plugins/plugin-8 -s "notification-plugin" --create -t string

xfconf-query -c xfce4-panel -p /plugins/plugin-9 -s "power-manager-plugin" --create -t string

xfconf-query -c xfce4-panel -p /plugins/plugin-10 -s "separator" --create -t string

xfconf-query -c xfce4-panel -p /plugins/plugin-11 -s "clock" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-11/digital-date-format -s "%a, %b %d, %Y" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-11/digital-time-format -s "%a, %b %d, %I:%M %p" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-11/digital-layout -s 3 --create -t uint
xfconf-query -c xfce4-panel -p /plugins/plugin-11/digital-time-font -s "Sans 10" --create -t string

xfconf-query -c xfce4-panel -p /plugins/plugin-12 -s "separator" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-12/style -s 0 --create -t uint

xfconf-query -c xfce4-panel -p /plugins/plugin-13 -s "systemload" --create -t string

