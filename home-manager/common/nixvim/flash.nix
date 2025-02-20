{
  programs.nixvim = {
    plugins.flash = {
      enable = true;
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
    keymaps = [
      {
        key = "<cr>";
        action = {
          __raw = ''function() require("flash").jump() end'';
        };
        options.desc = "Flash";
      }
    ];
  };
}
