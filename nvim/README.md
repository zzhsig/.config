# Neovim Config

Personal Neovim configuration built on [LazyVim](https://lazyvim.github.io/).

## Structure

```
init.lua                    # Entry point — loads config.lazy
lua/config/
  lazy.lua                  # Bootstraps lazy.nvim
  options.lua               # Custom options (wrap, mousescroll, server socket)
  keymaps.lua               # Custom keymaps
  autocmds.lua              # Custom autocommands
lua/plugins/
  colorscheme.lua           # GitHub Dark Dimmed theme
  picker.lua                # Snacks picker (Esc closes, hidden files shown)
  claude.lua                # Claude Code integration (claudecode.nvim)
  nvim-guide.lua            # Neovim Guide — ask questions via Claude agent
  markdown-preview.lua      # Markdown preview (iamcco + glow.nvim)
  java.lua                  # jdtls configured for Java 21 (Homebrew)
```

## Language Extras

JSON, Markdown, Python, TypeScript, Java (via `lazyvim.json`).

## Custom Keymaps

| Key           | Mode   | Action                    |
| ------------- | ------ | ------------------------- |
| `jk`          | Insert | Exit insert mode          |
| `Ctrl+a`      | N / I  | Beginning of line         |
| `Ctrl+e`      | Insert | End of line               |
| `Ctrl+f`      | Insert | Forward char              |
| `Option+BS`   | Insert | Backward delete word      |
| `<leader>jq`  | Visual | Format JSON with jq       |
| `<leader>gg`  | Normal | Lazygit                   |
| `<leader>ac`  | Normal | Toggle Claude Code        |
| `<leader>af`  | Normal | Focus Claude Code         |
| `<leader>aA`  | Normal | Add file to Claude        |
| `<leader>as`  | Visual | Send selection to Claude  |
| `<leader>ah`  | Normal | Ask Neovim Guide          |
| `<leader>aH`  | Normal | Neovim Guide History      |
| `<leader>cp`  | Normal | Markdown Preview          |
| `<leader>cg`  | Normal | Glow Preview              |

## Formatting

```sh
stylua lua/
```

See `stylua.toml` for settings (2-space indent, 120 col).
