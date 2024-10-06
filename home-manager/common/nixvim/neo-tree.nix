{
  programs.nixvim = {
    plugins.neo-tree = {
      enable = true;
      closeIfLastWindow = true;
      filesystem.followCurrentFile.enabled = true;
      buffers.followCurrentFile.enabled = true;
    };
    keymaps = [
      {
        key = "<leader>e";
        action = "<cmd>Neotree toggle<cr>";
        options = {
          desc = "Explorer NeoTree (Root Dir)";
          remap = true;
        };
      }
    ];
  };
}
