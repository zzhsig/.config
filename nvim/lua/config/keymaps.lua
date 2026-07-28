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

-- Ctrl+f = forward char (insert)
vim.keymap.set("i", "<C-f>", "<Right>", { desc = "Forward char" })

-- Backward delete word (Karabiner sends Option+Delete for Ctrl-W, which arrives as <M-BS>)
vim.keymap.set("i", "<M-BS>", "<C-w>", { desc = "Backward delete word" })

-- Format selected JSON with jq
vim.keymap.set("v", "<leader>jq", "!jq .<CR>", { desc = "Format JSON" })

-- Lazygit
vim.keymap.set("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })

-- Mouse wheel scrolls the window under the pointer *as if it were current*, so
-- scroll-synced windows (e.g. Diffview's two diff panes) move together on hover
-- without having to click into the pane first.
local function wheel_scroll(motion)
  local keys = vim.api.nvim_replace_termcodes(motion, true, false, true)
  return function()
    local win = vim.fn.getmousepos().winid
    if win == 0 or not vim.api.nvim_win_is_valid(win) then
      return
    end
    local step = tonumber(vim.o.mousescroll:match("ver:(%d+)")) or 3
    vim.api.nvim_win_call(win, function()
      vim.cmd("normal! " .. step .. keys)
    end)
  end
end
vim.keymap.set({ "n", "v" }, "<ScrollWheelDown>", wheel_scroll("<C-e>"), { desc = "Scroll window under mouse" })
vim.keymap.set({ "n", "v" }, "<ScrollWheelUp>", wheel_scroll("<C-y>"), { desc = "Scroll window under mouse" })
