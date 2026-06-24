# arch_dotfiles

My personal Arch Linux dotfiles, including configurations for Hyprland, Waybar, Wofi, Kitty, and Linux Wallpaper Engine.

## Structure

- `config/hypr`: Hyprland configuration (with workspace animation toggles, tiling toggle, custom sound bindings, etc.)
- `config/waybar`: Dual bar layout (top and bottom status bars with Spotify controls)
- `config/wofi`: Monochromatic off-white/off-black custom styling
- `config/kitty`: Nordic theme terminal configuration
- `systemd/user/linux-wallpaperengine.service`: Systemd service to auto-run wallpaper engine with layer and screen options

## Installation / Setup

To deploy these dotfiles, run the setup script:

```bash
chmod +x setup.sh
./setup.sh
```

The script will automatically back up any existing files in `~/.config` to `*.bak` and create symlinks pointing to this repository.
