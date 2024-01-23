return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = { mason = false },
        pyright = { mason = false },
        rnix = { mason = false },
        ruff_lsp = { mason = false },
        rust_analyzer = { mason = false },
        taplo = { mason = false },
      },
    },
  },
}
