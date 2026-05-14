return {
  -- Fugitive: Git commands
  { "tpope/vim-fugitive" },

  -- Gitsigns: inline git status markers
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "^" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local opts = { buffer = bufnr }

        vim.keymap.set("n", "]h", gs.next_hunk, opts)
        vim.keymap.set("n", "[h", gs.prev_hunk, opts)
        vim.keymap.set("n", "<leader>gp", gs.preview_hunk, opts)
        vim.keymap.set("n", "<leader>gs", gs.stage_hunk, opts)
        vim.keymap.set("n", "<leader>gr", gs.reset_hunk, opts)
        vim.keymap.set("n", "<leader>gb", gs.blame_line, opts)
      end,
    },
  },

  -- Diffview: side-by-side diff, PR review, file history
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview open (working changes)" },
      { "<leader>gD", "<cmd>DiffviewOpen main...HEAD<cr>", desc = "Diffview vs main (PR review)" },
      {
        "<leader>gg",
        function()
          require("telescope.builtin").git_branches({
            prompt_title = "Diff against branch",
            attach_mappings = function(_, map)
              map("i", "<CR>", function(prompt_bufnr)
                local selection = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
                require("telescope.actions").close(prompt_bufnr)
                vim.cmd("DiffviewOpen main..." .. selection.value)
              end)
              return true
            end,
          })
        end,
        desc = "Diffview: pick branch to diff",
      },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history (current)" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "File history (repo)" },
      { "<leader>w", "<cmd>DiffviewClose<cr>", desc = "Diffview close" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = { layout = "diff2_horizontal" },
        merge_tool = { layout = "diff3_mixed" },
      },
    },
  },
}
