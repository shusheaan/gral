local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local function is_markdown_buffer(bufnr)
  local filetype = vim.bo[bufnr].filetype
  return filetype == "markdown" or filetype == "mdx"
end

local function find_nearest_locator(line, cursor_col)
  local best = nil
  local best_distance = nil

  for start_idx, path, line_nr, col_nr, end_idx in line:gmatch("()([%w%._%-%+~/%\\]+):(%d+):(%d+)()") do
    local start_col = start_idx - 1
    local end_col = end_idx - 2
    local distance = 0

    if cursor_col < start_col then
      distance = start_col - cursor_col
    elseif cursor_col > end_col then
      distance = cursor_col - end_col
    end

    if best_distance == nil or distance < best_distance then
      best = {
        path = path,
        line = tonumber(line_nr),
        column = tonumber(col_nr),
      }
      best_distance = distance
    end
  end

  return best
end

local function push_unique(paths, path)
  local normalized = vim.fn.fnamemodify(vim.fn.expand(path), ":p")
  for _, existing in ipairs(paths) do
    if existing == normalized then
      return
    end
  end
  table.insert(paths, normalized)
end

local function locator_candidate_paths(raw_path, bufnr)
  local paths = {}

  if raw_path:sub(1, 1) == "/" or raw_path:sub(1, 1) == "~" then
    push_unique(paths, raw_path)
    return paths
  end

  local buf_path = vim.api.nvim_buf_get_name(bufnr)
  if buf_path ~= "" then
    push_unique(paths, vim.fn.fnamemodify(buf_path, ":p:h") .. "/" .. raw_path)
  end
  push_unique(paths, vim.fn.getcwd() .. "/" .. raw_path)

  return paths
end

local function resolve_locator_path(raw_path, bufnr)
  local paths = locator_candidate_paths(raw_path, bufnr)
  for _, path in ipairs(paths) do
    if vim.fn.filereadable(path) == 1 then
      return path, paths
    end
  end

  return nil, paths
end

local function set_cursor_from_locator(line_nr, col_nr)
  local line_count = vim.api.nvim_buf_line_count(0)
  local target_line = math.min(math.max(line_nr or 1, 1), line_count)
  local text = vim.api.nvim_buf_get_lines(0, target_line - 1, target_line, false)[1] or ""
  local target_col = math.min(math.max((col_nr or 1) - 1, 0), #text)

  vim.api.nvim_win_set_cursor(0, { target_line, target_col })
  vim.cmd("normal! zv")
end

local function open_markdown_locator()
  local line = vim.api.nvim_get_current_line()
  local cursor_col = vim.api.nvim_win_get_cursor(0)[2]
  local locator = find_nearest_locator(line, cursor_col)

  if locator == nil then
    local ok, err = pcall(vim.cmd, "normal! gF")
    if not ok then
      vim.notify(err, vim.log.levels.WARN)
    end
    return
  end

  local path, tried_paths = resolve_locator_path(locator.path, 0)
  if path == nil then
    vim.notify(
      "Locator file not found: " .. locator.path .. "\nTried:\n" .. table.concat(tried_paths, "\n"),
      vim.log.levels.ERROR
    )
    return
  end

  vim.cmd("edit " .. vim.fn.fnameescape(path))
  set_cursor_from_locator(locator.line, locator.column)
end

local function set_markdown_locator_keymaps(bufnr)
  vim.keymap.set("n", "gd", open_markdown_locator, {
    buffer = bufnr,
    desc = "Open file locator under cursor",
  })
end

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

-- Markdown project-nav locators: make gd behave like gF for ../path:line:column jumps.
autocmd("FileType", {
  group = augroup("MarkdownKeymaps", { clear = true }),
  pattern = { "markdown", "mdx" },
  callback = function(event)
    set_markdown_locator_keymaps(event.buf)
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

    -- gd / gD / gi / gy: definition / definition-in-vsplit / implementation / type definition.
    -- In Markdown, gd follows project-nav file locators instead of LSP definitions.
    if is_markdown_buffer(event.buf) then
      set_markdown_locator_keymaps(event.buf)
    else
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    end
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
