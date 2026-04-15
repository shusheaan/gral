-- Set leader key before lazy (must be first)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim and load plugins
require("config.lazy")

-- Core configuration
require("config.options")
require("config.keymaps")
require("config.autocmds")
