return {
  {
    "telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      commit = "6c921ca",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
  },
}
