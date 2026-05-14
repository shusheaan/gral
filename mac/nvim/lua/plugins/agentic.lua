return {
  "carlos-algms/agentic.nvim",
  event = "VeryLazy",
  dependencies = {
    { "hakonharnes/img-clip.nvim", opts = {} },
  },
  opts = {
    provider = "claude-agent-acp",
    windows = {
      position = "right",
      width = "40%",
    },
    diff_preview = {
      enabled = true,
      layout = "split",
      center_on_navigate_hunks = true,
    },
    folding = {
      tool_calls = { enabled = true, threshold = 10 },
    },
    acp_providers = {
      ["claude-agent-acp"] = {
        env = { ANTHROPIC_API_KEY = os.getenv("ANTHROPIC_API_KEY") },
      },
    },
    spinner_chars = {
      generating = { "·", "✢", "✳", "∗", "✻", "✽" },
      thinking   = { "·", "✢", "✳", "∗", "✻", "✽" },
      searching  = { ".  ", ".. ", "...", " ..", "  .", "   " },
    },
    diagnostic_icons = {
      error = "E",
      warn  = "W",
      info  = "I",
      hint  = "H",
    },
    message_icons = {
      thinking = "[think]",
      finished = "[done]",
      stopped  = "[stop]",
      error    = "[err]",
    },
  },
  config = function(_, opts)
    require("agentic").setup(opts)
    local function sync_title_hl()
      vim.api.nvim_set_hl(0, "AgenticTitle", { link = "StatusLine" })
    end
    sync_title_hl()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("AgenticTitleSync", { clear = true }),
      callback = sync_title_hl,
    })
  end,
  keys = {
    { "<C-\\>",      function() require("agentic").toggle() end,                            mode = { "n", "v", "i" }, desc = "Agentic: toggle chat" },
    { "<leader>ii",  function() require("agentic").toggle() end,                            mode = { "n", "v" },      desc = "Agentic: toggle chat" },
    { "<leader>ia",  function() require("agentic").add_selection_or_file_to_context() end,  mode = { "n", "v" },      desc = "Agentic: add file/selection to context" },
    { "<leader>if",  function() require("agentic").add_file() end,                          mode = "n",               desc = "Agentic: add current file" },
    { "<leader>iv",  function() require("agentic").add_selection() end,                     mode = "v",               desc = "Agentic: add visual selection" },
    { "<leader>in",  function() require("agentic").new_session() end,                       mode = { "n", "v" },      desc = "Agentic: new session" },
    { "<leader>ir",  function() require("agentic").restore_session() end,                   mode = "n",               desc = "Agentic: restore session" },
    { "<leader>is",  function() require("agentic").switch_provider() end,                   mode = "n",               desc = "Agentic: switch provider" },
    { "<leader>id",  function() require("agentic").add_buffer_diagnostics() end,            mode = "n",               desc = "Agentic: add buffer diagnostics" },
    { "<leader>iD",  function() require("agentic").add_current_line_diagnostics() end,      mode = "n",               desc = "Agentic: add line diagnostics" },
    { "<leader>iL",  function() require("agentic").rotate_layout() end,                     mode = "n",               desc = "Agentic: rotate layout" },
    { "<leader>ix",  function() require("agentic").stop_generation() end,                   mode = "n",               desc = "Agentic: stop generation" },
  },
}
