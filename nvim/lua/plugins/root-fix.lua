-- Fix E5108 "vim/fs:342: ENOENT" crash when opening the explorer (<leader>e)
-- on Neovim 0.12.
--
-- Background: Neovim 0.12's `vim.fs.find` now `assert(uv.cwd())`s when it is
-- given a nil/invalid `path`, whereas 0.11 silently returned no matches.
-- LazyVim's root pattern detector (lua/lazyvim/util/root.lua) computes
-- `path = bufpath or vim.uv.cwd()`. When Neovim's cwd no longer exists (stale
-- session, deleted directory, etc.) `vim.uv.cwd()` returns nil, so
-- `vim.fs.find(fn, { path = nil, upward = true })` raises the ENOENT assert.
--
-- Upstream LazyVim has not patched this yet (root.lua is identical on `main`),
-- so we guard it here. We also make `root.get()` fall back to a valid directory
-- so callers like `Snacks.explorer({ cwd = LazyVim.root() })` never receive nil.
return {
  "LazyVim/LazyVim",
  opts = function()
    local root = require("lazyvim.util.root")

    -- Guard the pattern detector: when there is no valid path to search from,
    -- bail out instead of letting vim.fs.find assert on a missing cwd.
    local pattern = root.detectors.pattern
    root.detectors.pattern = function(buf, patterns)
      local path = root.bufpath(buf) or vim.uv.cwd()
      if not path then
        return {}
      end
      return pattern(buf, patterns)
    end

    -- Ensure root.get() always returns an existing directory, even when the
    -- cwd has been deleted out from under Neovim.
    local get = root.get
    root.get = function(opts)
      local ok, ret = pcall(get, opts)
      if ok and ret and ret ~= "" then
        return ret
      end
      return vim.uv.cwd() or vim.uv.os_homedir() or vim.fs.normalize("~")
    end
  end,
}
