{
  programs.nixvim = {
    plugins.bufferline.enable = true;
    keymaps = [
      {
        key = "<leader>bo";
        action = "<Cmd>BufferLineCloseOthers<CR>";
        options = {
          desc = "Delete Other Buffers";
        };
      }
      {
        key = "[B";
        action = "<cmd>BufferLineMovePrev<cr>";
        options = {
          desc = "Move Buffer Prev";
        };
      }
      {
        key = "[b";
        action = "<cmd>BufferLineCyclePrev<cr>";
        options = {
          desc = "Prev Buffer";
        };
      }
      {
        key = "]B";
        action = "<cmd>BufferLineMoveNext<cr>";
        options = {
          desc = "Move Buffer Next";
        };
      }
      {
        key = "]b";
        action = "<cmd>BufferLineCycleNext<cr>";
        options = {
          desc = "Next Buffer";
        };
      }
    ];
  };
}
