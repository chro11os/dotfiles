# pydex — Plan

A Zed config repo for keyboard-first Python work. Goal: never reach for the mouse, but still be able to use it.

## Goals
1. Every action reachable from the keyboard
2. Run → terminal focus; stop → editor focus
3. Fast (Zed is native Rust + GPU)
4. Syntax highlighting (Zed built-in, tree-sitter)
5. Error lens (inline diagnostics)

## Decisions
| ID | Decision | Date |
|----|----------|------|
| D1 | Use Zed with config instead of forking VSCode or Zed, or building an editor | 2026-10-07 |
| D2 | pydex = a private GitHub repo of Zed config, symlinked into `~/.config/zed` by `install.sh` | 2026-10-07 |
| D3 | Python language servers: basedpyright (types) + ruff (lint/format) | 2026-10-07 |

## Revisit if
Zed can't close a gap through config. Options then, in order: report it upstream → patch a fork → build a custom editor.
