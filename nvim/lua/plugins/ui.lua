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
      local git_state = {
        is_repo = false,
        branch = "",
        dirty = false,
        ahead = 0,
        behind = 0,
        has_upstream = false,
      }
      local git_refreshing = false

      local function parse_git_status(output)
        local lines = vim.split(output or "", "\n", { plain = true, trimempty = true })
        local header = lines[1] or ""
        if not vim.startswith(header, "## ") then
          return {
            is_repo = false,
            branch = "",
            dirty = false,
            ahead = 0,
            behind = 0,
            has_upstream = false,
          }
        end

        local branch = header:gsub("^## ", ""):gsub("%.%.%..*", ""):gsub("%s+%[.*%]", "")
        local ahead = tonumber(header:match("ahead (%d+)")) or 0
        local behind = tonumber(header:match("behind (%d+)")) or 0

        return {
          is_repo = true,
          branch = branch,
          dirty = #lines > 1,
          ahead = ahead,
          behind = behind,
          has_upstream = header:find("%.%.%.") ~= nil,
        }
      end

      local function current_git_query_dir()
        local file_path = vim.api.nvim_buf_get_name(0)
        if file_path ~= "" then
          return vim.fs.dirname(file_path)
        end
        return vim.fn.getcwd()
      end

      local function refresh_git_state()
        if git_refreshing then
          return
        end
        git_refreshing = true

        vim.system({ "git", "-C", current_git_query_dir(), "status", "--porcelain=v1", "--branch" }, { text = true }, function(result)
          local next_state = {
            is_repo = false,
            branch = "",
            dirty = false,
            ahead = 0,
            behind = 0,
            has_upstream = false,
          }
          if result.code == 0 then
            next_state = parse_git_status(result.stdout)
          end

          vim.schedule(function()
            git_state = next_state
            git_refreshing = false
            pcall(require("lualine").refresh, { place = { "statusline" } })
          end)
        end)
      end

      local function git_branch()
        if not git_state.is_repo or git_state.branch == "" then
          return ""
        end

        local suffix = ""
        if git_state.dirty then
          suffix = suffix .. "*"
        end
        if git_state.ahead > 0 then
          suffix = suffix .. "↑" .. git_state.ahead
        end
        if git_state.behind > 0 then
          suffix = suffix .. "↓" .. git_state.behind
        end

        return " " .. git_state.branch .. suffix
      end

      local function git_branch_color()
        if git_state.dirty or git_state.ahead > 0 or not git_state.has_upstream then
          return { fg = "#d8a657" }
        end
        return { fg = "#a9b665" }
      end

      vim.api.nvim_create_autocmd({ "VimEnter", "BufEnter", "BufWritePost", "FocusGained", "DirChanged" }, {
        group = vim.api.nvim_create_augroup("LualineGitBranchState", { clear = true }),
        callback = refresh_git_state,
      })
      vim.schedule(refresh_git_state)

      return {
        options = {
          theme = "gruvbox",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = {
            {
              "mode",
              fmt = function(mode)
                return mode:lower()
              end,
            },
          },
          lualine_b = {
            {
              git_branch,
              color = git_branch_color,
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
            { "filename", path = 3, color = { fg = "#ebdbb2" } },
            {
              function()
                return vim.fn.getcwd()
              end,
              color = { fg = "#ebdbb2" },
            },
            "diff",
            "diagnostics",
          },
          lualine_x = {
            { function() return vim.lsp.status() end, color = { fg = "#fabd2f" } },
            "filetype",
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
