local map = vim.keymap.set

-- Basics
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>/", "<cmd>set hlsearch!<cr>", { desc = "Toggle search highlight" })
map("n", "<leader>[", "<C-b>", { desc = "Page up" })
map("n", "<leader>]", "<C-f>", { desc = "Page down" })
map("n", "<leader>j", "j", { desc = "Cursor down" })
map("n", "<leader>k", "k", { desc = "Cursor up" })

-- Window management
map("n", "<leader>a", "<cmd>vsplit<cr>", { desc = "Vertical split" })
map("n", "<leader>l", "<C-W><C-l>", { desc = "Window right" })
map("n", "<leader>h", "<C-W><C-h>", { desc = "Window left" })
map("n", "<leader>H", "<C-W>H", { desc = "Move window left" })
map("n", "<leader>L", "<C-W>L", { desc = "Move window right" })
map("n", "<leader>=", "<cmd>vertical resize +20<cr>", { desc = "Increase width" })
map("n", "<leader>-", "<cmd>vertical resize -20<cr>", { desc = "Decrease width" })
map("n", "<leader>,", "<cmd>res -20<cr>", { desc = "Decrease height" })
map("n", "<leader>.", "<cmd>res +20<cr>", { desc = "Increase height" })

-- Undotree
map("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "Undotree" })


-- Git (fugitive)
map("n", "gh", "<cmd>diffget //2<cr>", { desc = "Diffget ours" })
map("n", "gl", "<cmd>diffget //3<cr>", { desc = "Diffget theirs" })

-- Diagnostics
map("n", "[g", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]g", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- Rust-analyzer status
map("n", "<leader>rr", "<cmd>Ra<cr>", { desc = "Rust-analyzer status" })
