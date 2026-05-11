local M = {}

local scope_kind_names = {
  Class = true,
  Constructor = true,
  Function = true,
  Interface = true,
  Method = true,
  Module = true,
  Namespace = true,
  Struct = true,
}

local symbol_kind_labels = {
  [vim.lsp.protocol.SymbolKind.Class] = "Class",
  [vim.lsp.protocol.SymbolKind.Constructor] = "Constructor",
  [vim.lsp.protocol.SymbolKind.Function] = "Function",
  [vim.lsp.protocol.SymbolKind.Interface] = "Interface",
  [vim.lsp.protocol.SymbolKind.Method] = "Method",
  [vim.lsp.protocol.SymbolKind.Module] = "Module",
  [vim.lsp.protocol.SymbolKind.Namespace] = "Namespace",
  [vim.lsp.protocol.SymbolKind.Struct] = "Struct",
}

local function current_file()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    return nil
  end
  return vim.fs.normalize(file)
end

local function project_root()
  local file = current_file()
  local start = file and vim.fs.dirname(file) or vim.uv.cwd()
  local markers = {
    ".git",
    "AGENTS.md",
    "CLAUDE.md",
    "Cargo.toml",
    "pyproject.toml",
    "package.json",
    "go.mod",
  }

  for _, marker in ipairs(markers) do
    local found = vim.fs.find(marker, { path = start, upward = true, limit = 1 })[1]
    if found then
      return vim.fs.dirname(found)
    end
  end

  return vim.uv.cwd()
end

local function relative_path(root, file)
  local ok, relpath = pcall(vim.fs.relpath, root, file)
  if ok and relpath and relpath ~= "" then
    return relpath
  end
  return vim.fn.fnamemodify(file, ":.")
end

local function symbol_kind_name(kind)
  return symbol_kind_labels[kind] or vim.lsp.protocol.SymbolKind[kind] or "Symbol"
end

local function range_contains(range, line, character)
  if not range then
    return false
  end

  local start_pos = range.start
  local end_pos = range["end"]
  if line < start_pos.line or line > end_pos.line then
    return false
  end
  if line == start_pos.line and character < start_pos.character then
    return false
  end
  if line == end_pos.line and character > end_pos.character then
    return false
  end
  return true
end

local function range_score(range)
  return (range["end"].line - range.start.line) * 100000
    + (range["end"].character - range.start.character)
end

local function current_lsp_symbol(bufnr, line, character)
  local has_document_symbol = false
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    if client.supports_method("textDocument/documentSymbol", bufnr) then
      has_document_symbol = true
      break
    end
  end
  if not has_document_symbol then
    return nil
  end

  local params = {
    textDocument = vim.lsp.util.make_text_document_params(bufnr),
  }
  local responses = vim.lsp.buf_request_sync(bufnr, "textDocument/documentSymbol", params, 300)
  if not responses then
    return nil
  end

  local best_symbol = nil
  local best_score = math.huge

  local function consider(symbol, range)
    if not symbol or not range_contains(range, line, character) then
      return
    end

    local kind = symbol_kind_name(symbol.kind)
    if not scope_kind_names[kind] then
      return
    end

    local score = range_score(range)
    if score < best_score then
      best_score = score
      best_symbol = {
        kind = kind,
        name = symbol.name,
      }
    end
  end

  local function visit(symbol)
    consider(symbol, symbol.range)
    for _, child in ipairs(symbol.children or {}) do
      visit(child)
    end
  end

  for _, response in pairs(responses) do
    local result = response.result
    if type(result) == "table" then
      for _, symbol in ipairs(result) do
        if symbol.location then
          consider(symbol, symbol.location.range)
        else
          visit(symbol)
        end
      end
    end
  end

  return best_symbol
end

local function trim(text)
  return (text:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function field_text(node, bufnr, field_names)
  for _, field in ipairs(field_names) do
    local children = node:field(field)
    for _, child in ipairs(children or {}) do
      local ok, text = pcall(vim.treesitter.get_node_text, child, bufnr)
      if ok and text and text ~= "" then
        return trim(text:gsub("\n", " "))
      end
    end
  end
  return nil
end

local function first_lines_text(node, bufnr)
  local start_row, _, end_row, _ = node:range()
  local stop_row = math.min(start_row + 3, end_row + 1)
  return table.concat(vim.api.nvim_buf_get_lines(bufnr, start_row, stop_row, false), " ")
end

local function infer_name_from_text(text)
  local patterns = {
    "^%s*local%s+function%s+([%w_%.:]+)",
    "^%s*function%s+([%w_%.:]+)",
    "^%s*async%s+function%s+([%w_%.:]+)",
    "^%s*def%s+([%w_]+)",
    "^%s*fn%s+([%w_]+)",
    "^%s*class%s+([%w_]+)",
    "^%s*struct%s+([%w_]+)",
    "^%s*impl%s+([%w_]+)",
    "^%s*([%w_%.:]+)%s*=%s*function",
    "^%s*([%w_%.:]+)%s*=%s*%([^)]*%)%s*=>",
    "^%s*([%w_%.:]+)%s*%(",
  }

  for _, pattern in ipairs(patterns) do
    local name = text:match(pattern)
    if name then
      return name
    end
  end

  return nil
end

local function is_scope_node(node_type)
  return node_type:find("function")
    or node_type:find("method")
    or node_type:find("constructor")
    or node_type:find("class")
    or node_type:find("struct")
    or node_type:find("trait")
    or node_type:find("impl")
    or node_type == "mod_item"
end

local function current_treesitter_symbol(bufnr)
  local ok, node = pcall(vim.treesitter.get_node, { bufnr = bufnr })
  if not ok or not node then
    return nil
  end

  while node do
    local node_type = node:type()
    if is_scope_node(node_type) then
      local name = field_text(node, bufnr, { "name", "field" })
        or infer_name_from_text(first_lines_text(node, bufnr))
        or "anonymous"

      return {
        kind = node_type,
        name = name,
      }
    end

    node = node:parent()
  end

  return nil
end

local function current_symbol(bufnr, line, character)
  return current_lsp_symbol(bufnr, line, character) or current_treesitter_symbol(bufnr)
end

function M.copy()
  local file = current_file()
  if not file then
    vim.notify("Current buffer has no file path", vim.log.levels.WARN)
    return
  end

  local root = project_root()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = cursor[1]
  local column = cursor[2] + 1
  local symbol = current_symbol(0, line - 1, column - 1)
  local locator = relative_path(root, file) .. ":" .. line .. ":" .. column

  if symbol then
    locator = locator .. " (" .. symbol.kind .. " " .. symbol.name .. ")"
  end

  vim.fn.setreg('"', locator)
  pcall(vim.fn.setreg, "+", locator)
  vim.notify("Copied agent locator: " .. locator, vim.log.levels.INFO)
end

local function parse_locator(text)
  local path, line, column = text:match("^@?([^:\n]+):(%d+):(%d+)")
  if not path then
    path, line = text:match("^@?([^:\n]+):(%d+)")
  end
  if not path then
    path, line, column = text:match("@([%w%._%-%/%\\]+):(%d+):?(%d*)")
  end
  if not path then
    path, line, column = text:match("([%w%._%-%/%\\]+):(%d+):?(%d*)")
  end

  if path then
    path = trim(path)
  end
  return path, tonumber(line), tonumber(column)
end

local function existing_path(path)
  if path:sub(1, 1) == "/" and vim.uv.fs_stat(path) then
    return path
  end

  local bases = {
    project_root(),
    vim.uv.cwd(),
  }

  local file = current_file()
  if file then
    table.insert(bases, vim.fs.dirname(file))
  end

  for _, base in ipairs(bases) do
    local candidate = vim.fs.normalize(base .. "/" .. path)
    if vim.uv.fs_stat(candidate) then
      return candidate
    end
  end

  return nil
end

function M.open_from_clipboard()
  local text = vim.fn.getreg("+")
  if text == "" then
    text = vim.fn.getreg('"')
  end
  local path, line, column = parse_locator(text)
  if not path or not line then
    vim.notify("Clipboard does not contain a file:line locator", vim.log.levels.WARN)
    return
  end

  local file = existing_path(path)
  if not file then
    vim.notify("Locator file not found: " .. path, vim.log.levels.ERROR)
    return
  end

  vim.cmd.edit(vim.fn.fnameescape(file))
  vim.api.nvim_win_set_cursor(0, { line, math.max((column or 1) - 1, 0) })
end

return M
