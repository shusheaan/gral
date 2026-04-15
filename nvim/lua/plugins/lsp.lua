return {
  -- Mason: LSP/tool installer
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {},
  },

  -- Mason-lspconfig bridge
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

  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Python: basedpyright for type checking + completions
      lspconfig.basedpyright.setup({
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
      lspconfig.ruff.setup({
        capabilities = capabilities,
        on_attach = function(client)
          -- Defer hover to basedpyright
          client.server_capabilities.hoverProvider = false
        end,
      })

      -- Lua (for editing nvim config)
      lspconfig.lua_ls.setup({
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

      -- NOTE: rust-analyzer is handled by rustaceanvim, do NOT configure it here
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
              checkOnSave = {
                command = "clippy",
              },
              cargo = {
                allFeatures = true,
              },
              inlayHints = {
                enable = true,
                chainingHints = { enable = true },
                maxLength = 100,
              },
            },
          },
        },
      }
    end,
  },
}
