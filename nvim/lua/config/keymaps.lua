local map = vim.keymap.set

-- Basics
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>/", "<cmd>set hlsearch!<cr>", { desc = "Toggle search highlight" })
map("n", "<leader>[", "<C-b>", { desc = "Page up" })
map("n", "<leader>]", "<C-f>", { desc = "Page down" })

-- Window management
map("n", "<leader>s", "<cmd>split<cr>", { desc = "Horizontal split" })
map("n", "<leader>a", "<cmd>vsplit<cr>", { desc = "Vertical split" })
map("n", "<leader>j", "<C-W><C-j>", { desc = "Window down" })
map("n", "<leader>k", "<C-W><C-k>", { desc = "Window up" })
map("n", "<leader>l", "<C-W><C-l>", { desc = "Window right" })
map("n", "<leader>h", "<C-W><C-h>", { desc = "Window left" })
map("n", "<leader>J", "<C-W>J", { desc = "Move window down" })
map("n", "<leader>K", "<C-W>K", { desc = "Move window up" })
map("n", "<leader>H", "<C-W>H", { desc = "Move window left" })
map("n", "<leader>L", "<C-W>L", { desc = "Move window right" })
map("n", "<leader>=", "<cmd>vertical resize +20<cr>", { desc = "Increase width" })
map("n", "<leader>-", "<cmd>vertical resize -20<cr>", { desc = "Decrease width" })
map("n", "<leader>,", "<cmd>res -20<cr>", { desc = "Decrease height" })
map("n", "<leader>.", "<cmd>res +20<cr>", { desc = "Increase height" })

-- Undotree
map("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "Undotree" })

-- Rust log macros (<leader>l prefix = log)
map("n", "<leader>le", 'oerror!("{:#?}", );<ESC>hi', { desc = "Rust error!()" })
map("n", "<leader>ld", 'odebug!("{:#?}", );<ESC>hi', { desc = "Rust debug!()" })
map("n", "<leader>lt", 'otrace!("{:#?}", );<ESC>hi', { desc = "Rust trace!()" })
map("n", "<leader>li", 'oinfo!("{:#?}", );<ESC>hi', { desc = "Rust info!()" })

-- Git (fugitive)
map("n", "gs", "<cmd>Git<cr>", { desc = "Git status" })
map("n", "gh", "<cmd>diffget //2<cr>", { desc = "Diffget ours" })
map("n", "gl", "<cmd>diffget //3<cr>", { desc = "Diffget theirs" })

-- Diagnostics
map("n", "[g", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]g", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
