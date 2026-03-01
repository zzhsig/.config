# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration built on [LazyVim](https://lazyvim.github.io/) — a Neovim distro powered by lazy.nvim. All configuration is in Lua.

## Architecture

- `init.lua` — Entry point, loads `config.lazy`
- `lua/config/lazy.lua` — Bootstraps lazy.nvim and sets up plugin loading (imports `lazyvim.plugins` + `plugins/`)
- `lua/config/options.lua` — Custom vim options (extends LazyVim defaults)
- `lua/config/keymaps.lua` — Custom keymaps (loaded on VeryLazy event, extends LazyVim defaults)
- `lua/config/autocmds.lua` — Custom autocommands (loaded on VeryLazy event)
- `lua/plugins/*.lua` — Plugin specs; every file here is auto-loaded by lazy.nvim

## Key Conventions

- **LazyVim plugin pattern**: Override LazyVim plugins by adding a spec with the same plugin name in `lua/plugins/`. Use `opts` to merge config or `opts = function(_, opts)` for list-type options that need `vim.list_extend`.
- **Enabled extras**: `lazyvim.plugins.extras.lang.json` (see `lazyvim.json`)
- **Claude Code integration**: `claudecode.nvim` plugin in `lua/plugins/claude.lua` with keymaps under `<leader>a`
- **Formatter**: StyLua for Lua files (2-space indent, 120 column width — see `stylua.toml`)

## Formatting

```sh
stylua lua/
```

## Custom Keymaps

The user has custom keymaps in `lua/config/keymaps.lua`: `jk` for escape, Ctrl+a/e for line start/end, Option+Backspace for word delete. Preserve these when editing keymaps.
