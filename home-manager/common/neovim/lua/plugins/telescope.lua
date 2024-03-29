return {
  {
    "telescope.nvim",
    dependencies = {
      -- ref: https://github.com/LunarVim/LunarVim/issues/1804
      "nvim-telescope/telescope-fzf-native.nvim",
      commit = "6c921ca",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
  },
}
