local opt = vim.opt

-- Indentation
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

-- Line numbers
opt.number = true
opt.relativenumber = true

-- UI
opt.cursorline = true
opt.showmatch = true
opt.signcolumn = "yes"
opt.cmdheight = 1
opt.termguicolors = true
opt.fillchars:append({ vert = " " })

-- Behavior
opt.hidden = true
opt.backup = false
opt.swapfile = false
opt.writebackup = false
opt.undofile = true
opt.undodir = vim.fn.expand("~/.vim/undodir")
opt.incsearch = true
opt.updatetime = 300
opt.encoding = "utf-8"
opt.modifiable = true
opt.clipboard = "unnamedplus"
opt.errorbells = false

-- Folding
opt.foldmethod = "indent"
opt.foldlevel = 99

-- Scroll
opt.scrolloff = 8

-- Search
opt.path:append("**")
