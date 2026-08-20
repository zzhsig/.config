# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a macOS dotfiles repository (`~/.config`) managing configuration for: Neovim, Ghostty terminal, tmux, Karabiner-Elements, GitHub CLI, Git, and uv (Python package manager).

## Architecture

Each subdirectory is an independent tool's config:

- **`nvim/`** — LazyVim-based Neovim config (Lua). Has its own `CLAUDE.md` with detailed guidance. Plugin specs live in `nvim/lua/plugins/`. Format Lua with `stylua lua/` (2-space indent, 120 col — see `nvim/stylua.toml`).
- **`ghostty/config`** — Ghostty terminal config. Catppuccin Mocha theme, JetBrainsMono Nerd Font. Leaves Ctrl+a free for tmux prefix. Sends `ESC+DEL` for Option+Backspace so Neovim receives `<M-BS>`.
- **`karabiner/karabiner.json`** — System-wide keyboard remapping. Caps Lock → Left Control. Ctrl-G → Escape. Emacs-style Ctrl+N/P/B → Down/Up/Left arrows. Ctrl-W → Option+Delete (word-delete) everywhere except Ghostty.
- **`tmux/tmux.conf`** — tmux config. Prefix is Ctrl+t. Catppuccin Mocha status bar. Vim-aware pane navigation with Ctrl+h/j/k/l. Symlinked from `~/.tmux.conf`.
- **`gh/config.yml`** — GitHub CLI. Uses HTTPS protocol. Alias: `gh co` → `gh pr checkout`.
- **`git/ignore`** — Global gitignore (ignores `.claude/settings.local.json`).
- **`uv/`** — uv Python package manager receipt (installed to `~/.local/bin`).
- **`.emacs.d/`** — Emacs config (Emacs 31.1). This is its own git repo (remote
  `zzhjerry/jackrabbit-init`), nested inside this one and listed in `.gitignore`, so commit
  it separately. `~/.emacs.d` is a symlink to it, which is how Emacs finds it. Entry point is
  `init.el`, which `require`s modules from `lisp/` (core) and `packages/` (features) in
  dependency order. `use-package-always-ensure` is `t`, so packages auto-install from MELPA.
  Verify any change with `emacs --batch --load ~/.emacs.d/init.el` — it must produce no
  errors or warnings. The repo's own `.claude/skills/` has `emacs-config-verifier` and
  `fix-emacs` for this.

## Cross-tool Keybinding Chain

Karabiner, Ghostty, and Neovim keybindings are tightly coupled:

1. **Karabiner** remaps Caps Lock → Ctrl and Ctrl-W → Option+Delete (outside Ghostty)
2. **Ghostty** translates Option+Backspace → `ESC DEL` (`\x1b\x7f`)
3. **Neovim** maps `<M-BS>` (which is `ESC DEL`) → `<C-w>` (backward delete word)

Changing any link in this chain will break word-delete behavior. Test all three configs together when modifying keyboard mappings.

## Emacs Install

Emacs is the **prebuilt** `emacs-plus-app@next` cask (currently 31.1), not the
`emacs-plus@31` formula — the formula has no bottle and builds from a ~700MB git clone
plus a long compile, while the cask is the same emacs-plus build (same macOS patches,
xwidgets included) shipped as a binary. Upgrade with:

    brew upgrade --cask emacs-plus-app@next

`/Applications/Emacs.app` is owned by the cask; do not hand-copy an app there (a stale
copy is what caused a `libjpeg.10.dylib` load failure after a Homebrew `jpeg` bump).
`emacs-plus@30` is still installed but `brew unlink`ed as a fallback; remove with
`brew uninstall emacs-plus@30` to reclaim ~213MB.

## Editing Conventions

- **Karabiner JSON**: Machine-generated structure — keep formatting consistent with existing file. The `automatic_backups/` directory is managed by Karabiner; don't edit those files.
- **Ghostty config**: Simple `key = value` format, one setting per line. Comments with `#`.
- **Neovim**: See `nvim/CLAUDE.md` for full details. Key point: override LazyVim plugins by adding specs in `nvim/lua/plugins/` with the same plugin name.
