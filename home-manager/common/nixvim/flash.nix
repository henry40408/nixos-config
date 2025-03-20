{
  programs.nixvim = {
    plugins.flash = {
      enable = true;
      settings = {
        jump = {
          nohlsearch = true;
        };
        label = {
          uppercase = false;
          rainbow = {
            enabled = true;
          };
        };
      };
    };
    keymaps = [
      {
        key = "s";
        action = {
          __raw = ''function() require("flash").jump() end'';
        };
        options.desc = "Flash";
      }
    ];
  };
}
