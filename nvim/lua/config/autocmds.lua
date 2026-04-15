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

    -- gd: smart jump — tries definition → type definition → implementation
    vim.keymap.set("n", "gd", function()
      vim.lsp.buf.definition({
        on_list = function(result)
          if result and result.items and #result.items > 0 then
            vim.fn.setqflist({}, " ", result)
            vim.cmd("cfirst")
          else
            -- fallback: try type definition, then implementation
            vim.lsp.buf.type_definition({
              on_list = function(r2)
                if r2 and r2.items and #r2.items > 0 then
                  vim.fn.setqflist({}, " ", r2)
                  vim.cmd("cfirst")
                else
                  vim.lsp.buf.implementation()
                end
              end,
            })
          end
        end,
      })
    end, opts)

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
