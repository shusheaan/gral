-- LF file manager integration (no external plugin needed)
local function open_lf(dir)
  dir = dir or vim.fn.expand("%:p:h")
  local tempfile = vim.fn.tempname()
  local cmd = string.format("lf -selection-path=%s %s", vim.fn.shellescape(tempfile), vim.fn.shellescape(dir))

  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.9)
  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = "minimal",
    border = "rounded",
  })
  vim.api.nvim_set_option_value("winhighlight", "Normal:Normal,NormalFloat:Normal", { win = vim.api.nvim_get_current_win() })

  local job = vim.fn.termopen(cmd, {
    on_exit = function()
      vim.schedule(function()
        -- Close the float
        if vim.api.nvim_buf_is_valid(buf) then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
        -- Open selected files
        if vim.fn.filereadable(tempfile) == 1 then
          local lines = vim.fn.readfile(tempfile)
          vim.fn.delete(tempfile)
          for _, file in ipairs(lines) do
            if file ~= "" then
              vim.cmd("edit " .. vim.fn.fnameescape(file))
            end
          end
        end
      end)
    end,
  })

  vim.keymap.set("t", "<esc>", function() vim.fn.chansend(job, "q") end, { buffer = buf })

  vim.cmd("startinsert")
end

vim.keymap.set("n", "<leader>o", function() open_lf() end, { desc = "LF (current file)" })
vim.keymap.set("n", "<leader>O", function() open_lf(vim.fn.getcwd()) end, { desc = "LF (cwd)" })

return {}
