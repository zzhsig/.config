-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.spell = false
vim.opt.wrap = true
vim.opt.mousescroll = "ver:3,hor:0"

-- CursorHold fires after `updatetime` ms of inactivity. The docs panel
-- (nvim-docs-view, <leader>cD) refreshes on CursorHold, so keep this low so the
-- panel tracks the cursor with only a small debounce. LazyVim already uses 200,
-- set here explicitly to make the docs-panel dependency obvious.
vim.opt.updatetime = 200

-- Listen on a known socket for external "open file" commands (e.g. LocatorJS)
-- If another Neovim instance already owns this socket, skip silently.
local sock = "/tmp/nvim-server.sock"
pcall(os.remove, sock)
pcall(vim.fn.serverstart, sock)
