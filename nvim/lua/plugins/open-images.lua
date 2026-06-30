-- Open image files in macOS Preview instead of loading their binary content.
--
-- When Neovim is asked to read an image buffer -- whether from the shell
-- (`nvim picture.png`) or by "clicking"/selecting one in a picker, oil, netrw
-- or neo-tree -- this hijacks the read via a `BufReadCmd` autocmd, launches
-- macOS `open -a Preview` on the file, and wipes the empty buffer so you are
-- never left staring at binary garbage.
--
-- This is config-only (no plugin to install), so the spec is empty and the
-- autocmd is registered at module-load time, which happens during lazy.nvim's
-- spec import on startup -- early enough to intercept a file passed on the
-- command line.

local image_patterns = {
  "*.png",
  "*.jpg",
  "*.jpeg",
  "*.gif",
  "*.webp",
  "*.bmp",
  "*.tiff",
  "*.tif",
  "*.ico",
  "*.heic",
  "*.heif",
  "*.avif",
}

local group = vim.api.nvim_create_augroup("OpenImagesInPreview", { clear = true })

vim.api.nvim_create_autocmd("BufReadCmd", {
  group = group,
  pattern = image_patterns,
  callback = function(ev)
    local path = vim.fn.fnamemodify(ev.match, ":p")
    local bufnr = ev.buf

    -- Launch macOS Preview. `open` returns immediately; we do not need output.
    -- If the file does not exist on disk yet, skip the external open but still
    -- get rid of the empty buffer.
    if vim.fn.filereadable(path) == 1 then
      vim.fn.jobstart({ "open", "-a", "Preview", path }, { detach = true })
    else
      vim.notify("Image not found on disk: " .. path, vim.log.levels.WARN)
    end

    -- We are the BufReadCmd handler, so nothing was loaded into the buffer --
    -- it stays empty (no binary content). Now schedule its removal so Neovim
    -- returns to the previous buffer or a fresh empty one.
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end

      -- Find any window currently showing this image buffer and point it at a
      -- usable buffer first, so wiping out does not close the window/split.
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == bufnr then
          local alt = vim.fn.bufnr("#")
          if alt > 0 and alt ~= bufnr and vim.api.nvim_buf_is_valid(alt) then
            vim.api.nvim_win_set_buf(win, alt)
          else
            -- No alternate buffer (e.g. `nvim image.png`): create a fresh
            -- empty buffer so the window has something to show.
            local empty = vim.api.nvim_create_buf(true, false)
            vim.api.nvim_win_set_buf(win, empty)
          end
        end
      end

      pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
    end)
  end,
})

return {}
