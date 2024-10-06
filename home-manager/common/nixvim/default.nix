{
  imports = [
    ./appearance.nix
    ./bufferline.nix
    ./cmp.nix
    ./flash.nix
    ./keymaps.nix
    ./lsp.nix
    ./mini.nix
    ./neo-tree.nix
    ./plugins.nix
    ./treesitter.nix
  ];
  programs.nixvim = {
    enable = true;
    globals.mapleader = " ";
    opts = {
      # highlight current line
      cursorline = true;
      # line numbers
      number = true;
      relativenumber = true;
      # search
      ignorecase = true;
      smartcase = true;
      ruler = true; # show line and column when search
      # tabs
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      smarttab = true;
      # always show the signcolumn, otherwise text would be shifted when displaying error icons
      # https://github.com/Ahwxorg/nixvim-config/blob/d90d75bd7c69637e08cbd3969ec0373d6db7ffdc/config/options.nix
      signcolumn = "yes";
    };
  };
}
