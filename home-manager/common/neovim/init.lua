-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/echasnovski/mini.nvim",
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd("packadd mini.nvim | helptags ALL")
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require("mini.deps").setup({ path = { package = path_package } })

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- vim options
now(function()
  vim.g.mapleader = " "
  vim.opt.clipboard = "unnamedplus"
  vim.opt.expandtab = true
  vim.opt.sessionoptions = "buffers"
  vim.opt.shiftwidth = 2
  vim.opt.tabstop = 2
end)

-- keymap management
add({ source = "folke/which-key.nvim", commit = "8badb35" })
later(function()
  require("which-key").setup({
    spec = {
      { "<leader>f", group = "file/find" },
      { "<leader>q", group = "quit/session" },
      { "<leader>s", group = "search" },
      {
        "<leader>x",
        group = "diagnostics/quickfix",
        icon = { icon = "󱖫 ", color = "green" },
      },
      { "[", group = "prev" },
      { "]", group = "next" },
      { "g", group = "goto" },
      { "gs", group = "surround" },
      { "z", group = "fold" },
      {
        "<leader>b",
        group = "buffer",
        expand = function() return require("which-key.extras").expand.buf() end,
      },
      {
        "<leader>w",
        group = "windows",
        proxy = "<c-w>",
        expand = function() return require("which-key.extras").expand.win() end,
      },
    },
  })
  -- https://github.com/LazyVim/LazyVim/blob/13a4a84e3485a36e64055365665a45dc82b6bf71/lua/lazyvim/config/keymaps.lua
  -- buffers
  vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
  vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
  vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
  vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
  vim.keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
  vim.keymap.set("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
  vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete Buffer" })
  vim.keymap.set("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })
  -- clear search with <esc>
  vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })
  -- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
  vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
  vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
  vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
  vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
  vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
  vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
  -- better indent
  vim.keymap.set("v", "<", "<gv")
  vim.keymap.set("v", ">", ">gv")
  -- diagnostics/quickfix
  vim.keymap.set("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
  vim.keymap.set("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })
  -- quit
  vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
  -- windows
  vim.keymap.set("n", "<leader>w", "<c-w>", { desc = "Windows", remap = true })
  vim.keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
  vim.keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
  vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
end)

-- mini.nvim
add({ source = "echasnovski/mini.nvim", checkout = "c235203", depends = { "folke/which-key.nvim" } })
now(function()
  require("mini.basics").setup({})

  local starter = require("mini.starter")
  starter.setup({
    evaluate_single = true,
    items = {
      starter.sections.builtin_actions(),
      starter.sections.recent_files(3, false),
      starter.sections.recent_files(3, true),
    },
    content_hooks = {
      starter.gen_hook.adding_bullet(),
      starter.gen_hook.indexing("all", { "Builtin actions" }),
      starter.gen_hook.padding(3, 2),
    },
  })
end)
later(function()
  local wk = require("which-key")

  require("mini.ai").setup({})
  require("mini.bracketed").setup({})
  require("mini.bufremove").setup({})
  require("mini.comment").setup({})

  require("mini.completion").setup({})
  local imap_expr = function(lhs, rhs) vim.keymap.set("i", lhs, rhs, { expr = true }) end
  imap_expr("<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]])
  imap_expr("<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]])
  local keycode = vim.keycode or function(x) return vim.api.nvim_replace_termcodes(x, true, true, true) end
  local keys = {
    ["cr"] = keycode("<CR>"),
    ["ctrl-y"] = keycode("<C-y>"),
    ["ctrl-y_cr"] = keycode("<C-y><CR>"),
  }
  _G.cr_action = function()
    if vim.fn.pumvisible() ~= 0 then
      -- If popup is visible, confirm selected item or add new line otherwise
      local item_selected = vim.fn.complete_info()["selected"] ~= -1
      return item_selected and keys["ctrl-y"] or keys["ctrl-y_cr"]
    else
      -- If popup is not visible, use plain `<CR>`. You might want to customize
      -- according to other plugins. For example, to use 'mini.pairs', replace
      -- next line with `return require('mini.pairs').cr()`
      return keys["cr"]
    end
  end
  vim.keymap.set("i", "<CR>", "v:lua._G.cr_action()", { expr = true })

  require("mini.cursorword").setup({})
  require("mini.diff").setup({})
  require("mini.extra").setup({})

  require("mini.files").setup({})
  wk.add({ "<leader>e", function() require("mini.files").open() end, desc = "Explorer", mode = "n" })

  require("mini.hipatterns").setup({
    highlighters = {
      fixme = { pattern = "FIXME", group = "MiniHipatternsFixme" },
      hack = { pattern = "HACK", group = "MiniHipatternsHack" },
      todo = { pattern = "TODO", group = "MiniHipatternsTodo" },
      note = { pattern = "NOTE", group = "MiniHipatternsNote" },
    },
  })

  require("mini.icons").setup({})
  require("mini.indentscope").setup({})
  require("mini.move").setup({})
  require("mini.notify").setup({})
  require("mini.operators").setup({})
  require("mini.pairs").setup()

  require("mini.pick").setup({})
  wk.add({ "<leader>fb", "<cmd>Pick buffers<cr>", desc = "Buffers", mode = "n" })
  wk.add({ "<leader>ff", "<cmd>Pick files<cr>", desc = "Find Files", mode = "n" })
  wk.add({ "<leader>sg", "<cmd>Pick grep_live<cr>", desc = "Grep", mode = "n" })

  require("mini.statusline").setup({})
  require("mini.tabline").setup({})

  require("mini.surround").setup({
    mappings = {
      add = "gsa",
      delete = "gsd",
      find = "gsf",
      find_left = "gsF",
      highlight = "gsh",
      replace = "gsr",
      update_n_lines = "gsn",

      suffix_last = "l",
      suffix_next = "n",
    },
  })
end)

-- colorscheme
add({ source = "tinted-theming/base16-vim", checkout = "dfc1d89" })
later(function()
  vim.opt.termguicolors = true
  vim.cmd([[colorscheme base16-irblack]])
  -- fix highlight groups
  -- https://github.com/folke/tokyonight.nvim/blob/2c85fad417170d4572ead7bf9fdd706057bd73d7/extras/vim/colors/tokyonight-day.vim
  vim.api.nvim_set_hl(0, "MiniPickBorder", { link = "FloatBorder" })
  vim.api.nvim_set_hl(0, "MiniPickIconDirectory", { link = "Directory" })
  vim.api.nvim_set_hl(0, "MiniPickMatchCurrent", { link = "CursorLine" })
  vim.api.nvim_set_hl(0, "MiniPickMatchMarked", { link = "Visual" })
  vim.api.nvim_set_hl(0, "MiniPickNormal", { link = "NormalFloat" })
  vim.api.nvim_set_hl(0, "MiniPickNormal", { link = "Normal" })
  vim.api.nvim_set_hl(0, "MiniPickPreviewLine", { link = "CursorLine" })
  vim.api.nvim_set_hl(0, "MiniPickPreviewRegion", { link = "IncSearch" })
end)

-- lua development
add({ source = "Bilal2453/luvit-meta", commit = "ce76f6f" })
add({ source = "folke/lazydev.nvim", commit = "491452c", depends = { "Bilal2453/luvit-meta" } })
later(
  function()
    require("lazydev").setup({
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    })
  end
)

-- language server protocols
add({ source = "neovim/nvim-lspconfig", commit = "d3f169f" })
later(function()
  local lspconfig = require("lspconfig")
  local servers = {
    "gopls",
    "lua_ls",
    "nixd",
    "rust_analyzer",
  }
  for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup({})
  end
  lspconfig.volar.setup({
    filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
    },
    init_options = { vue = { hybridMode = false } },
  })
end)

-- auto format
add({ source = "stevearc/conform.nvim", commit = "40d4e98" })
later(
  function()
    require("conform").setup({
      formatters_by_ft = {
        javascript = { "prettierd" },
        json = { "prettierd" },
        lua = { "stylua" },
        markdown = { "prettierd" },
        nix = { "nixfmt" },
        typescript = { "prettierd" },
        vue = { "prettierd" },
      },
      format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
    })
  end
)

-- treesitter
add({
  source = "nvim-treesitter/nvim-treesitter",
  commit = "9d2acd4",
  hooks = { post_checkout = function() vim.cmd("TSUpdate") end },
})
later(function()
  ---@diagnostic disable-next-line:missing-fields
  require("nvim-treesitter.configs").setup({
    ensure_installed = {
      -- https://github.com/LazyVim/LazyVim/blob/13a4a84e3485a36e64055365665a45dc82b6bf71/lua/lazyvim/plugins/treesitter.lua
      "bash",
      "c",
      "diff",
      "html",
      "javascript",
      "jsdoc",
      "json",
      "jsonc",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
      "printf",
      "python",
      "query",
      "regex",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
      -- others
      "rust",
    },
  })
end)

-- terminal
add({ source = "akinsho/toggleterm.nvim", commit = "137d06f" })
later(function()
  require("toggleterm").setup({
    direction = "horizontal",
    open_mapping = [[<c-\>]],
  })
  -- terminal mappings
  vim.keymap.set("t", "<esc><esc>", [[<c-\><c-n>]], { desc = "Enter Normal Mode" })
  vim.keymap.set("t", "<c-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
  vim.keymap.set("t", "<c-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
  vim.keymap.set("t", "<c-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
  vim.keymap.set("t", "<c-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })
  vim.keymap.set("t", "<c-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
  vim.keymap.set("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })
end)

-- navigate
add({ source = "folke/flash.nvim", commit = "34c7be1" })
later(function()
  require("flash").setup({
    label = {
      rainbow = {
        enabled = true,
      },
    },
    modes = {
      search = {
        enabled = true,
      },
    },
  })
  vim.keymap.set({ "n", "o", "x" }, "s", function() require("flash").jump() end, { desc = "Flash" })
  vim.keymap.set({ "n", "o", "x" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
  vim.keymap.set("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })
  vim.keymap.set({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })
  vim.keymap.set("c", "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })
end)
