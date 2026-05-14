return {
  -- render-markdown: in-buffer rendering (headings, code blocks, tables, checkboxes, etc.)
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown" },
    opts = {
      -- when to render: 'n' = normal, 'c' = command, 'i' = insert, 't' = terminal
      -- omitting 'i' so raw markdown is visible while you're typing in insert mode
      render_modes = { "n", "c", "t" },

      heading = {
        sign = false,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        width = "block",
        left_margin = 0,
        left_pad = 1,
        right_pad = 2,
      },

      code = {
        style = "full",       -- show language name + icon at top of fence
        width = "block",
        left_pad = 2,
        right_pad = 2,
        border = "thin",
        sign = false,
      },

      bullet = {
        icons = { "•", "◦", "▪", "▫" },
      },

      checkbox = {
        unchecked = { icon = "󰄱 " },
        checked   = { icon = "󰱒 " },
        custom = {
          todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
        },
      },

      pipe_table = {
        style = "full",
        cell = "padded",
      },

      quote = { icon = "▎" },

      link = {
        enabled = true,
        image   = "󰥶 ",
        hyperlink = "󰌹 ",
      },
    },
    keys = {
      { "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", desc = "Render markdown toggle", ft = "markdown" },
    },
  },
}
