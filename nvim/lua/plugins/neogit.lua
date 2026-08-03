return {
  {
    -- these snacks picker keys shadow the Neogit bindings below
    "folke/snacks.nvim",
    keys = {
      { "<leader>gs", false },
      { "<leader>gp", false },
      { "<leader>gP", false },
    },
  },
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim", -- reuse the diffview integration for diffs
      "folke/snacks.nvim", -- picker/input backend
    },
    keys = {
      { "<leader>gs", "<cmd>Neogit<cr>", desc = "Neogit Status" },
      { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Neogit Commit" },
      { "<leader>gp", "<cmd>Neogit pull<cr>", desc = "Neogit Pull" },
      { "<leader>gP", "<cmd>Neogit push<cr>", desc = "Neogit Push" },
    },
    opts = {
      graph_style = "unicode",
      integrations = {
        diffview = true,
        snacks = true,
      },
    },
  },
}
