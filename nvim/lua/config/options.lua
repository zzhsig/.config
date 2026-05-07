-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.spell = false
vim.opt.wrap = true
vim.opt.mousescroll = "ver:3,hor:0"

-- Listen on a known socket for external "open file" commands (e.g. LocatorJS)
-- If another Neovim instance already owns this socket, skip silently.
local sock = "/tmp/nvim-server.sock"
pcall(os.remove, sock)
pcall(vim.fn.serverstart, sock)
