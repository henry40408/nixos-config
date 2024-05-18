-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {
  {
    'Saecki/crates.nvim',
    commit = 'd556c00',
    config = function()
      require('crates').setup()
    end
  }
}
