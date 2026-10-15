# dotfiles

My Zed, kitty and Neovim configs, for macOS and Ubuntu (Mac keyboard via [Toshy](https://github.com/RedBearAK/toshy)).

| Dir | Linked to |
|---|---|
| `zed/` | `~/.config/zed/{settings,keymap,tasks}.json`, `themes/pydex.json` |
| `kitty/` | `~/.config/kitty` |
| `nvim/` | `~/.config/nvim` (lazy.nvim bootstraps itself on first launch) |
| `toshy/` | `~/.config/toshy/{toshy_config.py,toshy_user_preferences.sqlite}` (Linux only) |

## Install

Prerequisites:
- **macOS:** [Homebrew](https://brew.sh) and `git`
- **Linux:** `git`, `curl`, `sudo`, and apt, dnf or pacman (other distros: install kitty + neovim yourself first)

```sh
git clone https://github.com/chro11os/dotfiles.git
cd dotfiles && ./setup.sh
```

`setup.sh` detects macOS vs Linux and installs whatever is missing:

| | macOS (brew) | Linux |
|---|---|---|
| Zed | `--cask zed` | zed.dev install script |
| kitty, Neovim | `--cask kitty`, `neovim` | apt / dnf / pacman |
| Iosevka Nerd Font | `--cask font-iosevka-nerd-font` | Nerd Fonts release → `~/.local/share/fonts` |
| Toshy | not needed (native Cmd) | cloned + `./setup_toshy.py install` (asks for sudo) |

It then symlinks everything into `~/.config` and backs up any existing real files/dirs to `*.bak`. Edits made in the apps (including the Toshy preferences GUI) land in this repo. Don't move the folder afterwards, or rerun `./setup.sh` if you do. Update later: `git pull`. After a fresh Toshy install, log out and back in.

Toshy upgrades (`toshy-reinstall`) rewrite `toshy_config.py` as a real file. Rerun `./setup.sh` afterwards; it moves that file to `.bak`, so copy over any changes you want to keep first.

# Zed (pydex)

- **Error lens:** diagnostics shown inline at the end of the line
- **Python:** basedpyright (types) + ruff (lint; format only on demand with Cmd+Shift+I, never on save)
- **Run:** `Cmd+R` runs the current file in the terminal and focuses it; when the script ends or you `Ctrl+C`, the terminal hides and focus goes back to the editor
- Uses `.venv/bin/python` if present, otherwise `python3`
- **Theme:** `pydex Dark` (Monokai syntax on Campbell black) and `pydex Paper` (inked syntax on warm paper white), following system light/dark
- **Font:** Iosevka Nerd Font Mono (editor + terminal)
- **Icons:** Symbols (extension auto-installs)
- **Claude Code** in the agent panel (Claude Agent)

Python runs with `.venv/bin/python` or `python3`. On a fresh Mac, `python3` asks to install the Xcode Command Line Tools the first time.

## Keys

All keys are **physical keys on a Mac keyboard**, and they're the same on macOS and on Linux with [Toshy](https://github.com/RedBearAK/toshy). Toshy sends physical Cmd to Zed as Ctrl and physical Ctrl as Super; `zed/keymap.json` has `os == linux` blocks that account for that.

| Key | Does |
|---|---|
| `Cmd+R` (or `Fn+F5`) | Run current Python file → focus terminal. Overrides Zed's Cmd+R (open recent) |
| `Ctrl+C` (in terminal) | Stop → terminal hides, focus returns to editor |
| `Cmd+J` | Toggle editor ↔ terminal (also shows the last run's output) |
| `Cmd+?` | Toggle editor ↔ Claude (agent panel) |
| `Cmd+C` / `Cmd+V` (in terminal) | Copy / paste. Ctrl+D, Ctrl+Z, Ctrl+R, etc. reach the shell as usual |

### Zed defaults worth knowing

With Toshy, the **Mac column applies on both machines** (physical keys). The Linux column is only for a non-Mac keyboard without Toshy. If one doesn't match, `Cmd+K Cmd+S` opens the keymap editor, which is the source of truth. F-keys need `Fn`.

| Mac | Linux | Does |
|---|---|---|
| `Cmd+Shift+P` | `Ctrl+Shift+P` | Command palette |
| `Cmd+P` | `Ctrl+P` | Fuzzy file finder |
| `Cmd+Shift+F` | `Ctrl+Shift+F` | Search project |
| `Cmd+Shift+O` | `Ctrl+Shift+O` | Jump to symbol in file |
| `Cmd+T` | `Ctrl+T` | Jump to symbol in project |
| `Cmd+Shift+E` | `Ctrl+Shift+E` | Focus file tree |
| `Cmd+Shift+M` | `Ctrl+Shift+M` | All project errors |
| `F8` / `Shift+F8` | `F8` / `Shift+F8` | Next / previous error |
| `Cmd+.` | `Ctrl+.` | Quick fix (code actions) |
| `F12` | `F12` | Go to definition |
| `F2` | `F2` | Rename symbol |
| `Ctrl+−` | `Ctrl+Alt+−` | Go back |
| `Ctrl+G` | `Ctrl+G` | Go to line |
| `Cmd+D` | `Ctrl+D` | Add next match (multi-cursor) |
| `Cmd+Shift+L` | `Ctrl+Shift+L` | Select all matches |
| `Opt+↑` / `Opt+↓` | `Alt+↑` / `Alt+↓` | Move line up / down |
| `Cmd+/` | `Ctrl+/` | Toggle comment |
| `Cmd+W` | `Ctrl+W` | Close tab |
| `Cmd+?` | `Ctrl+?` (`Ctrl+Shift+/`) | Toggle agent panel (Claude Agent lives here) |
| `Cmd+Opt+Shift+N` | `Ctrl+Alt+Shift+N` | New thread menu (in agent panel) → pick Claude Agent |
| `Cmd+>` | `Ctrl+>` | Send selection to the agent thread |
| `Cmd+K Cmd+S` | `Ctrl+K Ctrl+S` | Keymap editor (all bindings) |

## Smoke test

Open `examples/check.py` in Zed: line 3 should show a ruff warning, line 11 a type error, and `Cmd+R` should run a 5-second countdown.
