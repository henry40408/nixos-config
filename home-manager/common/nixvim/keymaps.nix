{
  programs.nixvim = {
    keymaps = [
      # https://github.com/LazyVim/LazyVim/blob/13a4a84e3485a36e64055365665a45dc82b6bf71/lua/lazyvim/config/keymaps.lua
      # better up / down
      {
        mode = [
          "n"
          "x"
        ];
        key = "j";
        action = "v:count == 0 ? 'gj' : 'j'";
        options = {
          desc = "Down";
          expr = true;
          silent = true;
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "<Down>";
        action = "v:count == 0 ? 'gj' : 'j'";
        options = {
          desc = "Down";
          expr = true;
          silent = true;
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "k";
        action = "v:count == 0 ? 'gk' : 'k'";
        options = {
          desc = "Up";
          expr = true;
          silent = true;
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "<Up>";
        action = "v:count == 0 ? 'gk' : 'k'";
        options = {
          desc = "Up";
          expr = true;
          silent = true;
        };
      }
      # move to window using the <ctrl+hjkl>
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w>h";
        options = {
          desc = "Go to Left Window";
          remap = true;
        };
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w>j";
        options = {
          desc = "Go to Lower Window";
          remap = true;
        };
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w>k";
        options = {
          desc = "Go to Upper Window";
          remap = true;
        };
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w>l";
        options = {
          desc = "Go to Right Window";
          remap = true;
        };
      }
      # resize window using <ctrl+arrow>
      # move lines
      # buffers
      # clear search with <esc>
      {
        mode = [
          "i"
          "n"
        ];
        key = "<esc>";
        action = "<cmd>noh<cr><esc>";
        options = {
          desc = "Escape and Clear hlsearch";
        };
      }
      # https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
      # add undo break-points
      # save file
      {
        mode = [
          "i"
          "x"
          "n"
          "s"
        ];
        key = "<C-s>";
        action = "<cmd>w<cr><esc>";
        options = {
          desc = "Save File";
        };
      }
      # keywordprg
      # better indenting
      # commenting
      # new file
      # quit
      {
        mode = "n";
        key = "<leader>qq";
        action = "<cmd>qa<cr>";
        options = {
          desc = "Quit All";
        };
      }
      # terminal mappings
      # windows
      # tabs
    ];
  };
}
