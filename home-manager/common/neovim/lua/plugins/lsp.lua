return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        cssls = {},
        docker_compose_language_service = {},
        dockerls = {},
        eslint = {},
        jsonls = {},
        lua_ls = {},
        marksman = {},
        nil_ls = { settings = { ["nil"] = { formatting = { command = { "nixfmt" } } } } },
        pyright = {},
        ruff = {},
        ruff_lsp = {},
        rust_analyzer = {},
        taplo = {},
        tsserver = {},
        volar = {},
      },
    },
  },
}
