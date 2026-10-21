#!/bin/sh
# Install Zed, VS Code, kitty, Neovim, Iosevka Nerd Font (+ Toshy on Linux), then symlink configs into ~/.config.
# Already-installed apps are skipped. Existing non-symlinks are backed up to *.bak.
set -e
repo="$(cd "$(dirname "$0")" && pwd)"
cfg="${XDG_CONFIG_HOME:-$HOME/.config}"
os="$(uname -s)"
have() { command -v "$1" >/dev/null; }

link() {  # link <repo path> <target>
  mkdir -p "$(dirname "$2")"
  if [ -e "$2" ] && [ ! -L "$2" ]; then mv "$2" "$2.bak"; fi
  ln -sfn "$repo/$1" "$2"
  echo "linked $2 -> $repo/$1"
}

# --- apps
if [ "$os" = Darwin ]; then
  if have brew; then
    have zed || [ -d /Applications/Zed.app ] || brew install --cask zed
    have kitty || [ -d /Applications/kitty.app ] || brew install --cask kitty
    have nvim || brew install neovim
    have code || [ -d "/Applications/Visual Studio Code.app" ] || brew install --cask visual-studio-code
    ls ~/Library/Fonts /Library/Fonts 2>/dev/null | grep -qi iosevka || brew install --cask font-iosevka-nerd-font
  else
    echo "note: Homebrew not found (https://brew.sh), skipping app installs"
  fi
elif [ "$os" = Linux ]; then
  have zed || curl -f https://zed.dev/install.sh | sh
  if ! have code; then
    if have snap; then sudo snap install code --classic
    else echo "note: install VS Code manually (https://code.visualstudio.com)"
    fi
  fi
  pkgs=""
  have kitty || pkgs="$pkgs kitty"
  have nvim || pkgs="$pkgs neovim"
  if [ -n "$pkgs" ]; then
    if have apt; then sudo apt install -y $pkgs
    elif have dnf; then sudo dnf install -y $pkgs
    elif have pacman; then sudo pacman -S --needed $pkgs
    else echo "note: install manually:$pkgs"
    fi
  fi
  if ! fc-list 2>/dev/null | grep -qi iosevka; then
    mkdir -p ~/.local/share/fonts/Iosevka
    curl -fL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Iosevka.tar.xz \
      | tar -xJ -C ~/.local/share/fonts/Iosevka --wildcards 'IosevkaNerdFont-*.ttf'
    fc-cache -f
  fi
  if [ ! -x ~/.local/bin/toshy-services-restart ]; then
    tmp="$(mktemp -d)"
    git clone --depth 1 https://github.com/RedBearAK/toshy "$tmp/toshy"
    (cd "$tmp/toshy" && ./setup_toshy.py install)
  fi
fi

# --- configs
# zed: per file, since ~/.config/zed also holds app state (prompts db etc.)
for f in settings.json keymap.json tasks.json themes/pydex.json; do
  link "zed/$f" "$cfg/zed/$f"
done
# vscode: settings + keybindings only, since the User dir also holds app state. Extensions from vscode/extensions.txt.
if [ "$os" = Darwin ]; then vsc="$HOME/Library/Application Support/Code/User"; else vsc="$cfg/Code/User"; fi
for f in settings.json keybindings.json; do link "vscode/$f" "$vsc/$f"; done
if have code; then
  installed="$(code --list-extensions)"
  while read -r ext; do
    echo "$installed" | grep -qix "$ext" || code --install-extension "$ext" </dev/null  # code reads stdin; would eat the list
  done < "$repo/vscode/extensions.txt"
fi
# kitty, nvim, fastfetch: whole dir
link kitty "$cfg/kitty"
link nvim "$cfg/nvim"
link fastfetch "$cfg/fastfetch"
# toshy: per file, since ~/.config/toshy also holds Toshy's own code + venv. Toshy hardcodes ~/.config.
if [ "$os" = Linux ]; then
  for f in toshy_config.py toshy_user_preferences.sqlite; do
    link "toshy/$f" "$HOME/.config/toshy/$f"
  done
  ~/.local/bin/toshy-services-restart >/dev/null 2>&1 || echo "note: log out and back in to start Toshy"
fi
