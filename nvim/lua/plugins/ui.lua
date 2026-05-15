return {
  -- Breadcrumb/current symbol provider for statusline
  {
    "SmiteshP/nvim-navic",
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {
      -- Keep nvim-navic's per-symbol colors for module/type/function names.
      highlight = true,
      separator = " › ",
      depth_limit = 5,
      safe_output = true,
    },
    config = function(_, opts)
      local navic = require("nvim-navic")
      navic.setup(opts)

      local function attach_navic(client, bufnr)
        if not client then
          return
        end

        if client:supports_method("textDocument/documentSymbol", bufnr) then
          navic.attach(client, bufnr)
        end
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("NavicAttach", { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          attach_navic(client, event.buf)
        end,
      })

      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
          attach_navic(client, bufnr)
        end
      end
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "SmiteshP/nvim-navic",
    },
    opts = function()
      local navic = require("nvim-navic")
      local function compact_path(path)
        if path == "" then
          return ""
        end

        local parts = {}
        local normalized = path:gsub("\\", "/"):gsub("/+$", "")
        for part in normalized:gmatch("[^/]+") do
          table.insert(parts, part)
        end

        if #parts == 0 then
          return normalized
        end

        return table.concat(parts, "/", math.max(#parts - 2, 1), #parts)
      end

      local function current_file_path()
        local statusline_winid = vim.g.statusline_winid
        local bufnr = vim.api.nvim_get_current_buf()
        if statusline_winid ~= nil and vim.api.nvim_win_is_valid(statusline_winid) then
          bufnr = vim.api.nvim_win_get_buf(statusline_winid)
        end

        local file_path = vim.api.nvim_buf_get_name(bufnr)
        if file_path == "" then
          return "[No Name]"
        end

        local label = compact_path(file_path)
        if vim.bo[bufnr].modified then
          label = label .. " [+]"
        end
        if vim.bo[bufnr].readonly then
          label = label .. " [-]"
        end
        return label
      end


      return {
        options = {
          theme = "gruvbox",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = {},
          lualine_b = {
            {
              "branch",
              icon = "",
              color = { fg = "#a9b665", gui = "bold" },
            },
            {
              function()
                return navic.get_location()
              end,
              cond = function()
                return navic.is_available()
              end,
              color = { fg = "#ebdbb2" },
            },
          },
          lualine_c = {
            { current_file_path, color = { fg = "#ebdbb2", gui = "bold" } },
            "diff",
            "diagnostics",
          },
          lualine_x = {
            {
              function()
                return compact_path(vim.fn.getcwd())
              end,
              color = { fg = "#ebdbb2", gui = "bold" },
            },
            { function() return vim.lsp.status() end, color = { fg = "#fabd2f" } },
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      }
    end,
  },

  -- Which-key: keybinding hints popup
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup({
        delay = 500, -- hold leader 0.5s to see hints
      })
      wk.add({
        { "<leader>f", desc = "Find files" },
        { "<leader>j", desc = "Recent files" },
        { "<leader>p", desc = "Project search (grep)" },
        { "<leader>w", desc = "Diffview close" },
        { "<leader>F", desc = "Grep word under cursor" },
        { "<leader>o", desc = "LF (open)" },
        { "<leader>g", group = "git" },
        { "<leader>d", group = "debug" },
        { "<leader>c", group = "code" },
        { "<leader>r", group = "rust" },
        { "<leader>m", group = "markdown" },
      })
    end,
  },

  -- Undotree
  { "mbbill/undotree" },

  -- CSV: load on BufReadPre (not FileType) so ftplugin is in rtp
  -- before nvim fires FileType csv. With ft="csv", lazy.nvim re-fires
  -- the event after loading, which races with syntax/csv.vim and trips
  -- "Invalid column pattern / ftplugin hasn't been sourced" warning.
  {
    "chrisbra/csv.vim",
    event = {
      { event = "BufReadPre", pattern = { "*.csv", "*.tsv", "*.tab", "*.dat" } },
      { event = "BufNewFile", pattern = { "*.csv", "*.tsv", "*.tab", "*.dat" } },
    },
  },

  -- Web devicons
  { "nvim-tree/nvim-web-devicons", lazy = true },
}
