return {
  {
    "folke/twilight.nvim",
    cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
    keys = {
      { "<leader>ut", "<cmd>Twilight<cr>", desc = "Toggle Twilight" },
    },
    opts = {
      dimming = {
        alpha = 0.25, -- 0 = fully dark, 1 = no dim
      },
      context = 10, -- lines of context around the active scope
      treesitter = true,
      expand = { "function", "method", "function_definition", "arrow_function", "table" },
    },
  },
}
