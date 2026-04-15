return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  keys = {
    { "<leader>f", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader><Tab>", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
    { "<leader>p", "<cmd>Telescope live_grep<cr>", desc = "Project search (grep)" },
    { "<leader>w", "<cmd>Telescope grep_string<cr>", desc = "Grep word under cursor" },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = { preview_width = 0.55 },
          width = 0.87,
          height = 0.80,
        },
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<Esc>"] = actions.close,
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          find_command = { "fd", "--type", "f", "--strip-cwd-prefix", "--hidden" },
        },
        oldfiles = { only_cwd = true },
      },
    })

    telescope.load_extension("fzf")
  end,
}
