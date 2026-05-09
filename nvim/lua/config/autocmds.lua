local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight cursor line only in insert mode
local cursorline_group = augroup("CursorLineInsert", { clear = true })
autocmd("InsertEnter", {
  group = cursorline_group,
  callback = function() vim.opt_local.cursorline = true end,
})
autocmd("InsertLeave", {
  group = cursorline_group,
  callback = function() vim.opt_local.cursorline = false end,
})

-- Close folds when opening a file so functions/classes start collapsed.
local close_folds_group = augroup("CloseFoldsOnOpen", { clear = true })
autocmd("BufReadPost", {
  group = close_folds_group,
  callback = function()
    vim.cmd("normal! zM")
  end,
})

-- LSP keybindings on attach (applies to ALL LSP servers including rustaceanvim)
autocmd("LspAttach", {
  group = augroup("LspKeymaps", { clear = true }),
  callback = function(event)
    -- Defer hover to basedpyright (ruff should not provide hover)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.name == "ruff" then
      client.server_capabilities.hoverProvider = false
    end

    -- Enable inlay hints (type annotations) if supported
    if client and client.supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
    end

    local opts = { buffer = event.buf, silent = true }

    -- gd / gD / gi / gy: definition / definition-in-vsplit / implementation / type definition
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", function()
      vim.cmd("vsplit")
      vim.lsp.buf.definition()
    end, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)

    -- gr: find all references (telescope UI)
    vim.keymap.set("n", "gr", function()
      require("telescope.builtin").lsp_references()
    end, opts)

    vim.keymap.set("n", "gk", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>cf", function()
      vim.lsp.buf.format({ async = true })
    end, opts)
    vim.keymap.set("n", "<leader>ci", function()
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      if #clients == 0 then
        vim.notify("No LSP clients attached to this buffer", vim.log.levels.WARN)
      else
        for _, c in ipairs(clients) do
          vim.notify(c.name .. " (id=" .. c.id .. ", root=" .. (c.root_dir or "nil") .. ")", vim.log.levels.INFO)
        end
      end
    end, { buffer = event.buf, silent = true, desc = "LSP clients on this buffer" })
  end,
})

-- CSV formatting (requires csv.vim)
-- Use FileType (not BufRead) so lazy.nvim loads csv.vim and its
-- ftplugin registers buffer-local :ArrangeColumn / :Sort first.
local csv_group = augroup("CSVEditing", { clear = true })
local function run_if_exists(cmd)
  if vim.fn.exists(":" .. cmd:match("^%s*%%?(%a+)")) == 2 then
    pcall(vim.cmd, cmd)
  end
end
autocmd("FileType", {
  group = csv_group,
  pattern = "csv",
  callback = function()
    run_if_exists("%ArrangeColumn")
    run_if_exists("%Sort 1")
  end,
})
autocmd("BufWritePost", {
  group = csv_group,
  pattern = "*.csv",
  callback = function()
    run_if_exists("%ArrangeColumn")
    run_if_exists("%Sort 1")
  end,
})
autocmd("BufWritePre", {
  group = csv_group,
  pattern = "*.csv",
  callback = function()
    run_if_exists("%UnArrangeColumn")
  end,
})

-- Ensure undo directory exists
vim.fn.mkdir(vim.fn.expand("~/.vim/undodir"), "p")

-- :Ra — quick rust-analyzer progress / workspace status
vim.api.nvim_create_user_command("Ra", function()
  local progress = vim.lsp.status()
  if progress == "" then
    progress = "(idle — no active progress)"
  end
  vim.notify("progress: " .. progress, vim.log.levels.INFO)
  local ok = vim.lsp.buf_request(0, "rust-analyzer/analyzerStatus", {}, function(err, res)
    if err or not res then
      vim.notify("analyzerStatus: unavailable (" .. vim.inspect(err) .. ")", vim.log.levels.WARN)
      return
    end
    -- First 2 lines of analyzerStatus are usually "workspace loaded" + counters
    local first = res:match("^[^\n]*\n?[^\n]*") or res
    vim.notify("rust-analyzer:\n" .. first, vim.log.levels.INFO)
  end)
  if not ok then
    vim.notify("no rust-analyzer client attached", vim.log.levels.WARN)
  end
end, { desc = "Rust-analyzer status & indexing progress" })
