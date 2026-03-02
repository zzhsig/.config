-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- jk to exit insert mode
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Ctrl+a = beginning of line (normal + insert)
vim.keymap.set("n", "<C-a>", "^", { desc = "Go to beginning of line" })
vim.keymap.set("i", "<C-a>", "<C-o>^", { desc = "Go to beginning of line" })

-- Ctrl+e = end of line (insert)
vim.keymap.set("i", "<C-e>", "<End>", { desc = "Go to end of line" })

-- Backward delete word (Karabiner sends Option+Delete for Ctrl-W, which arrives as <M-BS>)
vim.keymap.set("i", "<M-BS>", "<C-w>", { desc = "Backward delete word" })

-- Format selected JSON with jq
vim.keymap.set("v", "<leader>jq", "!jq .<CR>", { desc = "Format JSON" })
