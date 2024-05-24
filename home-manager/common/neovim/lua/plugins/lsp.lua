return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {},
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        docker_compose_language_service = { mason = false },
        dockerls = { mason = false },
        eslint = { mason = false },
        jsonls = { mason = false },
        lua_ls = { mason = false },
        marksman = { mason = false },
        nil_ls = {
          mason = false,
          settings = {
            ["nil"] = {
              formatting = {
                command = { "nixpkgs-fmt" },
              },
            },
          },
        },
        pyright = { mason = false },
        ruff = { mason = false },
        ruff_lsp = { mason = false },
        rust_analyzer = { mason = false },
        taplo = { mason = false },
        tsserver = { mason = false },
        volar = { mason = false },
      },
    },
  },
}
