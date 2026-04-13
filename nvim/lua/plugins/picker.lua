return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      win = {
        input = {
          keys = {
            ["<Esc>"] = { "close", mode = { "n", "i" } },
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
