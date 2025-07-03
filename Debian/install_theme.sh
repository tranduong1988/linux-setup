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

# cp xfce4-panel.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/

# edit panel 2
xfconf-query -c xfce4-panel -p /panels/panel-2/plugin-ids -r

for i in {11..18}; do
    xfconf-query -c xfce4-panel -p /panels/panel-2/plugin-ids -n -t int -s "$i"
done

xfconf-query -c xfce4-panel -p /plugins/plugin-14 -s "showdesktop" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-15 -s "separator" --create -t string

rename_launchers_safely 16
count=$(add_all_launchers_to_panel 2)

xfconf-query -c xfce4-panel -p /plugins/plugin-${count} -s "separator" --create -t string
((count++))
xfconf-query -c xfce4-panel -p /plugins/plugin-${count} -s "directorymenu" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-${count}/base-directory -s "$HOME" --create -t string


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
