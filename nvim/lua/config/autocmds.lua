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

-- LSP keybindings on attach (applies to ALL LSP servers including rustaceanvim)
autocmd("LspAttach", {
  group = augroup("LspKeymaps", { clear = true }),
  callback = function(event)
    local opts = { buffer = event.buf, silent = true }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gk", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>cf", function()
      vim.lsp.buf.format({ async = true })
    end, opts)
  end,
})

-- CSV formatting (requires csv.vim)
local csv_group = augroup("CSVEditing", { clear = true })
autocmd({ "BufRead", "BufWritePost" }, {
  group = csv_group,
  pattern = "*.csv",
  command = ":%ArrangeColumn",
})
autocmd({ "BufRead", "BufWritePost" }, {
  group = csv_group,
  pattern = "*.csv",
  command = ":%Sort 1",
})
autocmd("BufWritePre", {
  group = csv_group,
  pattern = "*.csv",
  command = ":%UnArrangeColumn",
})

-- Ensure undo directory exists
vim.fn.mkdir(vim.fn.expand("~/.vim/undodir"), "p")
