return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      -- Use a terminal split (vs floating window)
      terminal_cmd = nil, -- auto-detected
      terminal = {
        split_side = "right", -- "left" or "right"
        split_width_percentage = 0.40, -- 40% of screen width (default is 0.30)
      },
      diff_opts = {
        -- Show diffs in a vertical split
        vertical_split = true,
      },
    },
    keys = {
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude Code" },
      { "<leader>aA", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current file to Claude" },
      -- Visual mode: send selection to Claude
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", desc = "Send selection to Claude", mode = "v" },
    },
    config = function(_, opts)
      require("claudecode").setup(opts)
      -- Close Claude panel from inside terminal with <C-q>
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "*claude*",
        callback = function()
          vim.keymap.set("t", "<C-q>", "<C-\\><C-n><cmd>ClaudeCode<cr>", { buffer = true, desc = "Close Claude panel" })
        end,
      })
    end,
  },
}
