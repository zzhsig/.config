local history = {}

local function show_answer(question, answer)
  Snacks.win({
    buf = function()
      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(answer, "\n"))
      vim.bo[buf].filetype = "markdown"
      vim.bo[buf].buftype = "nofile"
      vim.bo[buf].bufhidden = "wipe"
      vim.bo[buf].modifiable = false
      return buf
    end,
    width = 0.8,
    height = 0.8,
    border = "rounded",
    title = " Neovim Guide: " .. question .. " ",
    title_pos = "center",
    wo = {
      wrap = true,
      linebreak = true,
      conceallevel = 2,
    },
    keys = {
      q = "close",
    },
  })
end

local function ask_guide(question)
  Snacks.notify("Asking nvim-guide...", { title = "Neovim Guide" })

  local stdout_chunks = {}
  local stderr_chunks = {}

  vim.fn.jobstart({ "env", "-u", "CLAUDECODE", "claude", "-p", "--agent", "nvim-guide", question }, {
    cwd = vim.fn.expand("~/.config"),
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        vim.list_extend(stdout_chunks, data)
      end
    end,
    on_stderr = function(_, data)
      if data then
        vim.list_extend(stderr_chunks, data)
      end
    end,
    on_exit = function(_, code)
      vim.schedule(function()
        if code ~= 0 then
          local err = vim.trim(table.concat(stderr_chunks, "\n"))
          Snacks.notify.error(err ~= "" and err or ("claude exited with code " .. code), { title = "Neovim Guide" })
          return
        end

        local response = vim.trim(table.concat(stdout_chunks, "\n"))
        if response == "" then
          Snacks.notify.error("Empty response from nvim-guide", { title = "Neovim Guide" })
          return
        end

        table.insert(history, { question = question, answer = response, time = os.date("%H:%M") })
        show_answer(question, response)
      end)
    end,
  })
end

return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>ah",
        function()
          vim.ui.input({ prompt = "Neovim Help: " }, function(question)
            if not question or question == "" then
              return
            end
            ask_guide(question)
          end)
        end,
        desc = "Ask Neovim Guide",
      },
      {
        "<leader>aH",
        function()
          if #history == 0 then
            Snacks.notify("No history yet", { title = "Neovim Guide" })
            return
          end

          local items = {}
          for i, entry in ipairs(history) do
            items[i] = {
              text = entry.question,
              preview = { text = entry.answer, ft = "markdown" },
              time = entry.time,
              entry = entry,
            }
          end

          Snacks.picker({
            title = "Neovim Guide History",
            items = items,
            format = function(item)
              local ret = {} ---@type snacks.picker.Highlight[]
              table.insert(ret, { item.time, "Comment" })
              table.insert(ret, { " " })
              table.insert(ret, { item.text, "Normal" })
              return ret
            end,
            confirm = function(picker, item)
              picker:close()
              show_answer(item.entry.question, item.entry.answer)
            end,
          })
        end,
        desc = "Neovim Guide History",
      },
    },
  },
}
