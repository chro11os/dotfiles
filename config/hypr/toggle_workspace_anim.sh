#!/usr/bin/env bash

if hyprctl animations | grep -A 3 'name: workspaces$' | grep -q 'enabled: 1'; then
    hyprctl eval 'hl.animation({ leaf = "workspaces", enabled = false }); hl.animation({ leaf = "workspacesIn", enabled = false }); hl.animation({ leaf = "workspacesOut", enabled = false })'
    hyprctl notify -1 2000 "rgb(ff0000)" "Workspace Animations: Disabled"
else
    hyprctl eval 'hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "slide" }); hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "slide" }); hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "slide" })'
    hyprctl notify -1 2000 "rgb(00ff00)" "Workspace Animations: Enabled"
    pw-play ~/.config/hypr/sounds/anim_on.mp3 &
fi
