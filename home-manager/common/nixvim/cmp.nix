{
  programs.nixvim = {
    plugins.luasnip.enable = true;
    plugins.cmp = {
      enable = true;
      autoEnableSources = true;
      settings = {
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
        snippet = {
          # otherwise: snippet engine is not configured
          expand = ''
            function(args)
              require('luasnip').lsp_expand(args.body)
            end
          '';
        };
        sources = [
          { name = "nvim_lsp"; }
          { name = "nvim_lsp_signature_help"; }
          { name = "nvim_lsp_document_symbol"; }
          { name = "path"; }
          { name = "buffer"; }
          {
            name = "luasnip";
            keywordLength = 3;
          }
        ];
      };
    };
  };
}
