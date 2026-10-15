#!/bin/sh
# Symlink zed, kitty and nvim configs into ~/.config. Existing non-symlinks are backed up to *.bak.
set -e
repo="$(cd "$(dirname "$0")" && pwd)"
cfg="${XDG_CONFIG_HOME:-$HOME/.config}"

link() {  # link <repo path> <target>
  mkdir -p "$(dirname "$2")"
  if [ -e "$2" ] && [ ! -L "$2" ]; then mv "$2" "$2.bak"; fi
  ln -sfn "$repo/$1" "$2"
  echo "linked $2 -> $repo/$1"
}

# zed: per file, since ~/.config/zed also holds app state (prompts db etc.)
for f in settings.json keymap.json tasks.json themes/pydex.json; do
  link "zed/$f" "$cfg/zed/$f"
done
# kitty, nvim: whole dir
link kitty "$cfg/kitty"
link nvim "$cfg/nvim"

have() { command -v "$1" >/dev/null; }
have zed || [ -d /Applications/Zed.app ] || echo "note: Zed not found. brew install --cask zed  (or: curl -f https://zed.dev/install.sh | sh)"
have kitty || [ -d /Applications/kitty.app ] || echo "note: kitty not found. brew install --cask kitty  (or: curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin)"
have nvim || echo "note: Neovim not found. brew install neovim  (or your distro's package)"
{ fc-list 2>/dev/null; ls ~/Library/Fonts /Library/Fonts 2>/dev/null; } | grep -qi iosevka || \
  echo "note: Iosevka Nerd Font not found. brew install --cask font-iosevka-nerd-font  (Linux: see README)"
