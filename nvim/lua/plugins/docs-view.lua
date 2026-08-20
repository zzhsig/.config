-- Always-on documentation panel: a persistent bottom split that renders the
-- LSP hover docs (signature / docstring) of the symbol under the cursor and
-- auto-updates as the cursor moves.
--
-- Uses nvim-docs-view, which requests `textDocument/hover` from the active LSP
-- client(s), converts the markdown response, and stylizes it into a dedicated
-- scratch buffer. Focus stays in the code window (it restores the previous
-- window after opening), and it no-ops gracefully when there is no LSP, no
-- symbol, or no docs (keeping the previous content instead of erroring).
--
-- Auto mode is driven by CursorHold / CursorHoldI, so how snappy it feels is
-- governed by `updatetime` (set in lua/config/options.lua).
return {
  "amrbashir/nvim-docs-view",
  lazy = true,
  cmd = { "DocsViewToggle", "DocsViewUpdate" },
  keys = {
    { "<leader>cD", "<cmd>DocsViewToggle<cr>", desc = "Toggle docs panel (LSP hover)" },
  },
  opts = {
    position = "bottom",
    height = 6,
    update_mode = "auto",
  },
}
