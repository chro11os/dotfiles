#!/usr/bin/env bash

# toggle_theme.sh
# Toggle system-wide color-scheme and GTK theme

CURRENT_SCHEME=$(gsettings get org.gnome.desktop.interface color-scheme)

if [ "$CURRENT_SCHEME" = "'prefer-dark'" ]; then
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'
    command -v notify-send >/dev/null && notify-send -h string:x-canonical-private-synchronous:theme "Theme" "Switched to Light Mode"
else
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
    command -v notify-send >/dev/null && notify-send -h string:x-canonical-private-synchronous:theme "Theme" "Switched to Dark Mode"
    pw-play ~/.config/hypr/sounds/theme_on.mp3 &
fi
