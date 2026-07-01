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
          -- Append a right-side, human-readable file size to each file row.
          format = function(item, picker)
            local ret = Snacks.picker.format.file(item, picker)
            if not item.dir then
              local stat = vim.uv.fs_stat(item.file)
              if stat then
                local size, units, u = stat.size, { "B", "K", "M", "G", "T" }, 1
                while size >= 1024 and u < #units do
                  size, u = size / 1024, u + 1
                end
                local str = u == 1 and ("%d%s"):format(size, units[u]) or ("%.1f%s"):format(size, units[u])
                ret[#ret + 1] = { " " .. str, "SnacksPickerDir" }
              end
            end
            return ret
          end,
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
