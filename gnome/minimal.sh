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

gnome-extensions disable ubuntu-dock@ubuntu.com
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
