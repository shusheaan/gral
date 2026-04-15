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
        lualine_x = { "encoding", "fileformat", "filetype" },
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
        { "<leader><Tab>", desc = "Recent files" },
        { "<leader>p", desc = "Project search (grep)" },
        { "<leader>w", desc = "Grep word under cursor" },
        { "<leader>o", desc = "LF (open)" },
        { "<leader>g", group = "git" },
        { "<leader>d", group = "debug" },
        { "<leader>c", group = "code" },
        { "<leader>l", group = "log (rust)" },
      })
    end,
  },

  -- Undotree
  { "mbbill/undotree" },

  -- CSV
  { "chrisbra/csv.vim", ft = "csv" },

  -- Web devicons
  { "nvim-tree/nvim-web-devicons", lazy = true },
}
