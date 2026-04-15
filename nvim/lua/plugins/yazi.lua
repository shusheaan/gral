return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>f", "<cmd>Yazi<cr>", desc = "Yazi (current file)" },
    { "<leader>F", "<cmd>Yazi cwd<cr>", desc = "Yazi (cwd)" },
  },
  opts = {
    open_for_directories = false,
    floating_window_scaling_factor = 0.9,
  },
}
