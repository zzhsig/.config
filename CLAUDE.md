# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a macOS dotfiles repository (`~/.config`) managing configuration for: Neovim, Ghostty terminal, Karabiner-Elements, GitHub CLI, Git, and uv (Python package manager).

## Architecture

Each subdirectory is an independent tool's config:

- **`nvim/`** — LazyVim-based Neovim config (Lua). Has its own `CLAUDE.md` with detailed guidance. Plugin specs live in `nvim/lua/plugins/`. Format Lua with `stylua lua/` (2-space indent, 120 col — see `nvim/stylua.toml`).
- **`ghostty/config`** — Ghostty terminal config. Catppuccin Mocha theme, JetBrainsMono Nerd Font. Leaves Ctrl+a free for tmux prefix. Sends `ESC+DEL` for Option+Backspace so Neovim receives `<M-BS>`.
- **`karabiner/karabiner.json`** — System-wide keyboard remapping. Caps Lock → Left Control. Ctrl-G → Escape. Emacs-style Ctrl+N/P/B → Down/Up/Left arrows. Ctrl-W → Option+Delete (word-delete) everywhere except Ghostty.
- **`gh/config.yml`** — GitHub CLI. Uses HTTPS protocol. Alias: `gh co` → `gh pr checkout`.
- **`git/ignore`** — Global gitignore (ignores `.claude/settings.local.json`).
- **`uv/`** — uv Python package manager receipt (installed to `~/.local/bin`).

## Cross-tool Keybinding Chain

Karabiner, Ghostty, and Neovim keybindings are tightly coupled:

1. **Karabiner** remaps Caps Lock → Ctrl and Ctrl-W → Option+Delete (outside Ghostty)
2. **Ghostty** translates Option+Backspace → `ESC DEL` (`\x1b\x7f`)
3. **Neovim** maps `<M-BS>` (which is `ESC DEL`) → `<C-w>` (backward delete word)

Changing any link in this chain will break word-delete behavior. Test all three configs together when modifying keyboard mappings.

## Editing Conventions

- **Karabiner JSON**: Machine-generated structure — keep formatting consistent with existing file. The `automatic_backups/` directory is managed by Karabiner; don't edit those files.
- **Ghostty config**: Simple `key = value` format, one setting per line. Comments with `#`.
- **Neovim**: See `nvim/CLAUDE.md` for full details. Key point: override LazyVim plugins by adding specs in `nvim/lua/plugins/` with the same plugin name.
