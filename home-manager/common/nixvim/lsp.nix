{ pkgs, ... }:
{
  programs.nixvim = {
    extraPackages = with pkgs; [ nodePackages.prettier ];
    plugins.cmp = {
      enable = true;
      autoEnableSources = true;
      settings = {
        # https://github.com/LazyVim/LazyVim/blob/ec5981dfb1222c3bf246d9bcaa713d5cfa486fbd/lua/lazyvim/plugins/extras/coding/nvim-cmp.lua#L38-L54
        mapping = {
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-e>" = "cmp.mapping.abort()";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-j>" = "cmp.mapping.select_next_item()";
          "<C-k>" = "cmp.mapping.select_prev_item()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<S-CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
        };
        snippet.expand = ''
          function(args)
            require('luasnip').lsp_expand(args.body)
          end'';
        sources = [
          { name = "nvim_lsp"; }
          { name = "nvim_lsp_signature_help"; }
          { name = "path"; }
          {
            name = "luasnip";
            keywordLength = 3;
          }
          { name = "buffer"; }
        ];
      };
    };
    plugins.conform-nvim = {
      enable = true;
      settings = {
        format_on_save = {
          # https://github.com/nix-community/nixvim/issues/2601
          __raw = "{}";
        };
        formatters_by_ft = {
          css = [ "prettier" ];
          html = [ "prettier" ];
          javascript = [ "prettier" ];
          javascriptreact = [ "prettier" ];
          json = [ "prettier" ];
          markdown = [ "prettier" ];
          nix = [ "nixfmt" ];
          python = [ "ruff_format" ];
          toml = [ "taplo" ];
          typescript = [ "prettier" ];
          typescriptreact = [ "prettier" ];
          yaml = [ "prettier" ];
        };
      };
    };
    plugins.friendly-snippets.enable = true;
    plugins.lsp = {
      enable = true;
      # https://github.com/LazyVim/LazyVim/blob/ec5981dfb1222c3bf246d9bcaa713d5cfa486fbd/lua/lazyvim/plugins/lsp/keymaps.lua#L16-L38
      onAttach = ''
        local opts = { buffer = bufnr }
        vim.keymap.set("n", "<leader>cl", "<cmd>LspInfo<cr>", { buffer = bufnr, desc = "Lsp Info" })
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Goto Definition" })
        vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "References", nowait = true })
        vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { buffer = bufnr, desc = "Goto Implementation" })
        vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "Goto T[y]pe Definition" })
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Goto Declaration" })
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover" })
        vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })
        vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename" })
        vim.keymap.set("i", "<c-k>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code Action" })
        vim.keymap.set({ "n", "v" }, "<leader>cc", vim.lsp.codelens.run, { buffer = bufnr, desc = "Run Codelens" })
        vim.keymap.set("n", "<leader>cC", vim.lsp.codelens.refresh, { buffer = bufnr, desc = "Refresh & Display Codelens" })
      '';
      servers.denols.enable = true;
      servers.emmet_language_server.enable = true;
      servers.eslint.enable = true;
      servers.nixd.enable = true;
      servers.ruff.enable = true;
      servers.pyright.enable = true;
      servers.taplo.enable = true;
      servers.ts_ls.enable = true;
      servers.rust_analyzer = {
        enable = true;
        package = null; # rust-analyzer should be managed by rustup
        installCargo = false;
        installRustc = false;
        settings = {
          check = {
            command = "clippy";
          };
        };
      };
    };
    plugins.luasnip.enable = true;
    plugins.none-ls.enable = true;
    plugins.treesitter = {
      enable = true;
      settings = {
        ensure_installed = [
          "nix"
          "python"
        ];
      };
    };
  };
}
