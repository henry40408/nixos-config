return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "csv",
          "nix",
        })
      end
    end,
  },
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
