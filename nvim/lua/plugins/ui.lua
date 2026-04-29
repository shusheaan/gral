return {
  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "gruvbox",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = {
          { "filename", path = 1 },
          { function() return vim.fn.fnamemodify(vim.fn.getcwd(), ":~") end, color = { fg = "#a89984" } },
        },
        lualine_x = {
          { function() return vim.lsp.status() end, color = { fg = "#fabd2f" } },
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
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
