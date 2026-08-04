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

          -- Open the file under the cursor in the OTHER window, never in the Claude split.
          -- Real paths (e.g. lua/foo.lua:42) open directly and jump to the line.
          -- Bare basenames (e.g. modes.py, which Claude writes in prose) fall back to
          -- the snacks file picker, seeded with the name so you just hit <cr>.
          local function open_in_other_win()
            local file = vim.fn.expand("<cfile>")
            if file == "" then
              return
            end
            local line = vim.fn.expand("<cWORD>"):match(":(%d+)")
            vim.cmd("wincmd p") -- back to the code window (Claude split lives on the right)
            if vim.bo.buftype == "terminal" then
              vim.cmd("wincmd h") -- fallback: no code window to return to, step left
            end

            if vim.fn.filereadable(vim.fn.fnamemodify(file, ":p")) == 1 then
              vim.cmd("edit " .. vim.fn.fnameescape(file))
              if line then
                vim.cmd(tostring(line))
              end
            else
              -- Not a resolvable path — fuzzy-find by basename in the code window.
              require("snacks").picker.files({ pattern = vim.fn.fnamemodify(file, ":t") })
            end
          end
          vim.keymap.set(
            "n",
            "gf",
            open_in_other_win,
            { buffer = true, desc = "Open file under cursor in other window" }
          )
          vim.keymap.set("n", "gF", open_in_other_win, { buffer = true, desc = "Open file+line in other window" })
        end,
      })
    end,
  },
}
