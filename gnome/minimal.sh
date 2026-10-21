#!/usr/bin/env bash
# Paper-white, monochrome, monospace GNOME look.
# Undo everything: dconf load / < "$(dirname "$0")/before-minimal.dconf"
set -e
here="$(cd "$(dirname "$0")" && pwd)"

I=org.gnome.desktop.interface
gsettings set $I color-scheme 'default'   # light; kitty follows via light-theme.auto.conf
gsettings set $I gtk-theme 'Yaru'
gsettings set $I icon-theme 'Yaru'
gsettings set $I accent-color 'slate'
gsettings set $I font-name 'Iosevka Nerd Font 11'
gsettings set $I monospace-font-name 'Iosevka Nerd Font 11'

W=org.gnome.desktop.wm.preferences
gsettings set $W button-layout ':close'
gsettings set $W titlebar-font 'Iosevka Nerd Font Bold 11'

B=org.gnome.desktop.background
gsettings set $B picture-uri ''
gsettings set $B picture-uri-dark ''
gsettings set $B picture-options 'none'
gsettings set $B color-shading-type 'solid'
gsettings set $B primary-color '#e8e8e4'

# Slim floating dock at the bottom; colors and square corners come from the Paper theme
D=org.gnome.shell.extensions.dash-to-dock
gsettings set $D dock-position 'BOTTOM'
gsettings set $D extend-height false
gsettings set $D dock-fixed false
gsettings set $D autohide true
gsettings set $D intellihide true
gsettings set $D dash-max-icon-size 28
gsettings set $D custom-theme-shrink true
gsettings set $D show-trash false
gsettings set $D show-mounts false
gsettings set $D show-show-apps-button false
gsettings set $D transparency-mode 'DEFAULT'
gsettings set $D custom-background-color false
gsettings set $D running-indicator-style 'DOTS'
gsettings set $D custom-theme-customize-running-dots true
gsettings set $D custom-theme-running-dots-color '#1c1b19'
gsettings set $D custom-theme-running-dots-border-width 0
gnome-extensions enable ubuntu-dock@ubuntu.com
gnome-extensions disable ding@rastersoft.com

# Top bar theme (needs the gnome-shell-extensions package)
mkdir -p ~/.local/share/themes
ln -sfn "$here/Paper" ~/.local/share/themes/Paper
ext=user-theme@gnome-shell-extensions.gcampax.github.com
if gnome-extensions info $ext >/dev/null 2>&1; then
  gnome-extensions enable $ext
  gsettings set org.gnome.shell.extensions.user-theme name 'Paper'
else
  echo "Top bar theme skipped: install gnome-shell-extensions, log out/in, rerun."
fi
