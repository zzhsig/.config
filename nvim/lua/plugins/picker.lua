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
          actions = {
            explorer_expand_all = function(picker)
              local tree = require("snacks.explorer.tree")
              local function expand_node(node)
                if not node.dir then
                  return
                end
                tree:expand(node) -- scan children from disk
                node.open = true -- mark for rendering
                for _, child in pairs(node.children or {}) do
                  expand_node(child)
                end
              end
              expand_node(tree:find(picker:cwd()))
              require("snacks.explorer.actions").update(picker, { refresh = true })
            end,
          },
          win = {
            list = {
              keys = {
                ["E"] = "explorer_expand_all",
              },
            },
          },
        },
      },
    },
  },
}
