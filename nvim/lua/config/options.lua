-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.spell = false

-- Listen on a known socket for external "open file" commands (e.g. LocatorJS)
local sock = "/tmp/nvim-server.sock"
pcall(os.remove, sock)
vim.fn.serverstart(sock)
