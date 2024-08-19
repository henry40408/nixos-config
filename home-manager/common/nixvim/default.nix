{ ... }: {
  programs.nixvim = {
    enable = true;
    colorschemes = {
      base16 = {
        enable = true;
        colorscheme = "dracula";
      };
    };
    keymaps = [
      {
        action = "<ESC>:Neotree toggle<CR>";
        key = "<leader>e";
      }
      {
        action = "<ESC>:update<CR>";
        key = "<C-S>";
        mode = [ "i" "n" "v" ];
      }
      {
        action = "<ESC>:nohl<CR>";
        key = "<ESC><ESC>";
      }
    ];
    opts = {
      number = true;
      relativenumber = false;
    };
    plugins = {
      bufferline = { enable = true; };
      conform-nvim = {
        enable = true;
        formattersByFt = { nix = [ "nixfmt" ]; };
        formatOnSave = {
          lspFallback = true;
          timeoutMs = 500;
        };
        notifyOnError = true;
      };
      flash = { enable = true; };
      gitsigns = { enable = true; };
      neo-tree = { enable = true; };
      lsp = {
        enable = true;
        servers.nil-ls.enable = true;
      };
      lualine = { enable = true; };
      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
        };
      };
      toggleterm = {
        enable = true;
        settings = {
          direction = "float";
          float_opts = {
            border = "curved";
            height = 30;
            width = 130;
          };
          open_mapping = "[[<leader>t]]";
        };
      };
      which-key = { enable = true; };
    };
  };
}
