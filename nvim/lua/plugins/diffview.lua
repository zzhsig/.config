-- Pick a sensible base ref: prefer origin/<branch>, fall back to the local branch.
local function diff_against(branch)
  local remote = "origin/" .. branch
  local ok = vim.fn.system({ "git", "rev-parse", "--verify", "--quiet", remote })
  if vim.v.shell_error == 0 and ok ~= "" then
    return remote
  end
  return branch
end

return {
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewFileHistory",
    },
    keys = {
      { "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
      { "<leader>gV", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview File History" },
      {
        "<leader>gm",
        function()
          require("diffview").open(diff_against("main") .. "...HEAD")
        end,
        desc = "Diffview vs main",
      },
      {
        "<leader>gn",
        function()
          require("diffview").open(diff_against("develop") .. "...HEAD")
        end,
        desc = "Diffview vs develop",
      },
    },
    opts = {
      file_panel = {
        listing_style = "list", -- flat list shows full relative paths (toggle with `i`)
        win_config = {
          position = "bottom", -- "left" | "right" | "top" | "bottom"
          height = 20, -- use height for top/bottom panels (width is ignored)
        },
      },
    },
  },
}
