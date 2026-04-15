return {
  -- Mason: LSP/tool installer
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {},
  },

  -- Mason-lspconfig bridge (auto-install servers)
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "basedpyright",
        "ruff",
        "lua_ls",
      },
    },
  },

  -- LSP configuration (nvim 0.11 native API)
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Python: basedpyright for type checking + completions
      vim.lsp.config("basedpyright", {
        capabilities = capabilities,
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "standard",
            },
          },
        },
      })

      -- Python: ruff for linting + formatting
      vim.lsp.config("ruff", {
        capabilities = capabilities,
      })

      -- Lua (for editing nvim config)
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.enable({ "basedpyright", "ruff", "lua_ls" })
    end,
  },

  -- Rustaceanvim: enhanced Rust support
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    lazy = false,
    init = function()
      vim.g.rustaceanvim = {
        server = {
          default_settings = {
            ["rust-analyzer"] = {
              check = {
                command = "clippy",
              },
              cargo = {
                allFeatures = true,
              },
              inlayHints = {
                typeHints = { enable = true },
                parameterHints = { enable = true },
                chainingHints = { enable = true },
                closingBraceHints = { enable = true, minLines = 10 },
                closureReturnTypeHints = { enable = "always" },
                maxLength = 100,
              },
            },
          },
        },
      }
    end,
  },
}
