return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      win = {
        input = {
          keys = {
            ["<Esc>"] = { "close", mode = { "n", "i" } },
            ["<S-Up>"] = { "history_back", mode = { "i", "n" } },
            ["<S-Down>"] = { "history_forward", mode = { "i", "n" } },
          },
        },
      },
      sources = {
        files = {
          hidden = true,
        },
        grep = {
          hidden = true,
        },
        explorer = {
          hidden = true,
          ignored = true,
        },
      },
    },
  },
}
