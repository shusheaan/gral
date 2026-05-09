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
opt.cmdheight = 0
opt.termguicolors = true
opt.fillchars:append({ vert = " " })
opt.splitright = true
opt.splitbelow = true

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
opt.foldenable = true
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 0
opt.foldlevelstart = 0

-- Timeouts
opt.timeoutlen = 10000

-- Scroll
opt.scrolloff = 8

-- Search
opt.path:append("**")

-- Diagnostics (error/warning display like VS Code)
vim.diagnostic.config({
  virtual_text = { spacing = 2, prefix = "●" },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = true },
})
