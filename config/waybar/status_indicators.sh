#!/usr/bin/env bash

MODE=$1

# Off-white active circle color: #faf8f6
# Off-black inactive circle color: #121212

if [ "$MODE" = "anim" ]; then
    if hyprctl animations | grep -A 3 'name: workspaces$' | grep -q 'enabled: 1'; then
        echo '{"text":"󰏏  <span color=\"#faf8f6\">●</span>","class":"enabled","tooltip":"Workspace Animations: Enabled"}'
    else
        echo '{"text":"󰏏  <span color=\"#121212\">●</span>","class":"disabled","tooltip":"Workspace Animations: Disabled"}'
    fi
elif [ "$MODE" = "tiling" ]; then
    if [ -f "$HOME/.cache/hyprland_tiling_mode" ]; then
        echo '{"text":"󱗕  <span color=\"#faf8f6\">●</span>","class":"enabled","tooltip":"Tiling Mode: Enabled"}'
    else
        echo '{"text":"󱗕  <span color=\"#121212\">●</span>","class":"disabled","tooltip":"Floating Mode: Enabled"}'
    fi
elif [ "$MODE" = "theme" ]; then
    CURRENT_SCHEME=$(gsettings get org.gnome.desktop.interface color-scheme)
    if [ "$CURRENT_SCHEME" = "'prefer-dark'" ]; then
        echo '{"text":"󰖔","class":"enabled","tooltip":"Theme: Dark Mode"}'
    else
        echo '{"text":"󰖨","class":"disabled","tooltip":"Theme: Light Mode"}'
    fi
fi
