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
          -- Close the explorer once a file is opened.
          auto_close = true,
          jump = { close = true },
          -- Show the explorer as a near-fullscreen float instead of a left sidebar.
          layout = {
            preview = false,
            layout = {
              box = "vertical",
              width = 0.95,
              height = 0.95,
              border = "rounded",
              title = "{title} {live} {flags}",
              title_pos = "center",
              { win = "input", height = 1, border = "bottom" },
              { win = "list", border = "none" },
            },
          },
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
              local cwd = picker:cwd()

              -- Collect git-ignored paths so we don't recurse into large ignored
              -- folders (node_modules, build dirs, ...). `--directory` collapses a
              -- fully-ignored directory to a single entry, so we only skip the dir
              -- itself, never a folder that merely contains some ignored files.
              local ignored = {}
              local out = vim.fn.systemlist({
                "git",
                "-C",
                cwd,
                "ls-files",
                "--others",
                "--ignored",
                "--exclude-standard",
                "--directory",
              })
              if vim.v.shell_error == 0 then
                for _, rel in ipairs(out) do
                  ignored[vim.fs.normalize(cwd .. "/" .. rel:gsub("/$", ""))] = true
                end
              end

              local function expand_node(node)
                if not node.dir then
                  return
                end
                tree:expand(node) -- scan children from disk
                node.open = true -- mark for rendering
                for _, child in pairs(node.children or {}) do
                  -- Skip the .git directory and anything git-ignored.
                  if child.name ~= ".git" and not ignored[vim.fs.normalize(child.path)] then
                    expand_node(child)
                  end
                end
              end
              expand_node(tree:find(cwd))
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
