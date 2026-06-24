#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Setting up dotfiles..."

# Helper function to create symlinks with backup
link_config() {
    local src="$1"
    local dest="$2"
    
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        if [ -L "$dest" ]; then
            echo "Removing existing symlink: $dest"
            rm "$dest"
        else
            echo "Backing up existing directory/file: $dest to ${dest}.bak"
            mv "$dest" "${dest}.bak"
        fi
    fi
    
    echo "Linking $src -> $dest"
    ln -s "$src" "$dest"
}

# Create necessary directories
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.config/systemd/user"

# Link configurations
link_config "$SCRIPT_DIR/config/hypr" "$HOME/.config/hypr"
link_config "$SCRIPT_DIR/config/waybar" "$HOME/.config/waybar"
link_config "$SCRIPT_DIR/config/wofi" "$HOME/.config/wofi"
link_config "$SCRIPT_DIR/config/kitty" "$HOME/.config/kitty"
link_config "$SCRIPT_DIR/systemd/user/linux-wallpaperengine.service" "$HOME/.config/systemd/user/linux-wallpaperengine.service"

# Reload systemd user daemon and enable service
echo "Reloading systemd user services..."
systemctl --user daemon-reload
systemctl --user enable linux-wallpaperengine.service

echo "Dotfiles setup completed successfully!"
