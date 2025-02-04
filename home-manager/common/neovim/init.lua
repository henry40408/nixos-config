local LANGUAGE_SERVERS = {
  "eslint",
  "gopls",
  "lua_ls",
  "nixd",
  "taplo",
}

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
  vim.opt.expandtab = true
  vim.opt.sessionoptions = "buffers"
  vim.opt.shiftwidth = 2
  vim.opt.tabstop = 2

  --  https://github.com/Alexis12119/nvim-config/blob/9efdf7bc943fe7f6d6dd39fdb6f070972e7c91e6/lua/core/autocommands.lua#L49-L61
  local autocmd = vim.api.nvim_create_autocmd
  local augroup = vim.api.nvim_create_augroup
  local general = augroup("General", { clear = true })
  autocmd({ "BufReadPost", "BufNewFile" }, {
    once = true,
    callback = function()
      -- In wsl 2, just install xclip
      -- Ubuntu
      -- sudo apt install xclip
      -- Arch linux
      -- sudo pacman -S xclip
      vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
    end,
    group = general,
    desc = "Lazy load clipboard",
  })
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
  local wk = require("which-key")

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

  require("mini.pick").setup({})
  wk.add({ "<leader>fb", "<cmd>Pick buffers<cr>", desc = "Buffers", mode = "n" })
  wk.add({ "<leader>ff", "<cmd>Pick files<cr>", desc = "Find Files", mode = "n" })
  wk.add({ "<leader>fg", "<cmd>Pick git_files<cr>", desc = "Find Files (git)", mode = "n" })
  wk.add({ "<leader>sg", "<cmd>Pick grep_live<cr>", desc = "Grep", mode = "n" })
end)
later(function()
  local wk = require("which-key")

  require("mini.ai").setup({})
  require("mini.bracketed").setup({})
  require("mini.bufremove").setup({})
  require("mini.comment").setup({})

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

-- completion
add({ source = "rafamadriz/friendly-snippets", commit = "de8fce9" })
add({
  source = "L3MON4D3/LuaSnip",
  commit = "e808bee",
  depends = {
    "rafamadriz/friendly-snippets",
  },
})
add({ source = "hrsh7th/cmp-buffer", commit = "3022dbc" })
add({ source = "hrsh7th/cmp-cmdline", commit = "d250c63" })
add({ source = "hrsh7th/cmp-nvim-lsp", commit = "39e2eda" })
add({ source = "hrsh7th/cmp-nvim-lsp-signature-help", commit = "031e6ba" })
add({ source = "hrsh7th/cmp-path", commit = "91ff86c" })
add({ source = "saadparwaiz1/cmp_luasnip", commit = "05a9ab2" })
add({
  source = "hrsh7th/nvim-cmp",
  commit = "ae644fe",
  depends = {
    "L3MON4D3/LuaSnip",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-path",
    "saadparwaiz1/cmp_luasnip",
  },
})
later(function()
  -- load snippets such as vbase-3-ts-setup
  require("luasnip.loaders.from_vscode").lazy_load()

  local cmp = require("cmp")
  local luasnip = require("luasnip")
  cmp.setup({
    snippet = {
      expand = function(args) require("luasnip").lsp_expand(args.body) end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          if luasnip.expandable() then
            luasnip.expand()
          else
            cmp.confirm({
              select = true,
            })
          end
        else
          fallback()
        end
      end),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.locally_jumpable(1) then
          luasnip.jump(1)
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "nvim_lsp_signature_help" },
      { name = "luasnip" },
      { name = "path" },
    }, {
      { name = "buffer", keyword_length = 3 },
    }),
  })
  cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" },
    },
  })
  cmp.setup.cmdline({ ":" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
      { name = "cmdline" },
    }),
  })
end)

-- language server protocols
add({ source = "neovim/nvim-lspconfig", commit = "d3f169f" })
later(function()
  local wk = require("which-key")

  local function on_attach()
    local keys = {
      { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
      { "gd", vim.lsp.buf.definition, desc = "Goto Definition" },
      { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
      { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
      { "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
      { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
      { "K", vim.lsp.buf.hover, desc = "Hover" },
      { "gK", vim.lsp.buf.signature_help, desc = "Signature Help" },
      { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help" },
      { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" } },
      { "<leader>cc", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "v" } },
      { "<leader>cC", vim.lsp.codelens.refresh, desc = "Refresh & Display Codelens", mode = { "n" } },
      { "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
    }
    for _index, key in ipairs(keys) do
      wk.add(key)
    end
  end

  local lspconfig = require("lspconfig")
  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  for _, lsp in ipairs(LANGUAGE_SERVERS) do
    lspconfig[lsp].setup({ capabilities = capabilities, on_attach = on_attach })
  end
  lspconfig.pylsp.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      pylsp = {
        plugins = {
          rope_autoimport = { enabled = true },
        },
      },
    },
  })
  lspconfig.rust_analyzer.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      ["rust-analyzer"] = {
        check = {
          command = "clippy",
        },
      },
    },
  })
  lspconfig.volar.setup({
    capabilities = capabilities,
    filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
    },
    init_options = { vue = { hybridMode = false } },
    on_attach = on_attach,
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
        python = { "yapf" },
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
    direction = "float",
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

-- startup time
add({ source = "dstein64/vim-startuptime", commit = "ac2cccb" })
