
sudo pacman -S --noconfirm ttf-roboto
sudo pacman -S --noconfirm ttf-0xproto-nerd 

paru -S --noconfirm qogir-icon-theme
paru -S --noconfirm materia-gtk-theme
paru -S --noconfirm orchis-theme

xfconf-query -c xsettings -p /Net/ThemeName -s "Materia-dark"
xfconf-query -c xsettings -p /Net/IconThemeName -s "Qogir-dark"
xfconf-query -c xfwm4 -p /general/theme -s "Materia-dark"

xfconf-query -c xsettings -p /Gtk/FontName -s "Roboto Regular 10"
xfconf-query -c xfwm4 -p /general/title_font -s "Roboto Bold 9"
xfconf-query -c xfce4-terminal -p /font-name -s "0xProto Nerd Font Regular 12"
