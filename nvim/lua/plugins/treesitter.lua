return {
  -- Ensure parsers needed for HTML with embedded CSS and JSX/babel scripts.
  -- `tsx` handles JSX syntax (e.g. <Component />) inside <script type="text/babel">.
  -- The actual injection of `tsx` into babel script tags is done via the
  -- custom query at nvim/after/queries/html/injections.scm.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
      })
    end,
  },
}
