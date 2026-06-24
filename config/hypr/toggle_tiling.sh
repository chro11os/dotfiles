#!/usr/bin/env bash

STATE_FILE="$HOME/.cache/hyprland_tiling_mode"

if [ -f "$STATE_FILE" ]; then
    rm "$STATE_FILE"
    hyprctl eval 'if floatAllRule then floatAllRule:set_enabled(true) end'
    hyprctl notify -1 2000 "rgb(ff0000)" "Floating Mode Enabled"
else
    touch "$STATE_FILE"
    hyprctl eval 'if floatAllRule then floatAllRule:set_enabled(false) end'
    hyprctl notify -1 2000 "rgb(00ff00)" "Tiling Mode Enabled"
    pw-play ~/.config/hypr/sounds/tiling_on.mp3 &
fi
