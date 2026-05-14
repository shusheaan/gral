return {
  "ellisonleao/gruvbox.nvim",
  priority = 1000,
  config = function()
    require("gruvbox").setup({
      contrast = "",
      transparent_mode = false,
      overrides = {
        SignColumn = { bg = "NONE" },
      },
    })
    vim.o.background = "dark"
    vim.cmd.colorscheme("gruvbox")
  end,
}
