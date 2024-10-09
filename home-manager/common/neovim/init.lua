-- automatically install lazy.nvim [[
local lazy_version = "v11.14.1"
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    string.format("--branch=%s", lazy_version),
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
-- ]]

-- vim options [[
vim.g.mapleader = " "

vim.opt.clipboard = "unnamedplus"
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
-- ]]

-- setup auto completion framework [[
local function config_cmp()
  local plugin = require("cmp")
  local luasnip = require("luasnip")
  local lspkind = require("lspkind")
  plugin.setup({
    view = { entries = "custom" },
    formatting = { format = lspkind.cmp_format() },
    snippet = {
      expand = function(args) require("luasnip").lsp_expand(args.body) end,
    },
    mapping = plugin.mapping.preset.insert({
      ["<C-e>"] = plugin.mapping.abort(),
      -- SuperTab flavor [[
      ["<CR>"] = plugin.mapping(function(fallback)
        if plugin.visible() then
          if luasnip.expandable() then
            luasnip.expand()
          else
            plugin.confirm({
              select = true,
            })
          end
        else
          fallback()
        end
      end),
      ["<Tab>"] = plugin.mapping(function(fallback)
        if plugin.visible() then
          plugin.select_next_item()
        elseif luasnip.locally_jumpable(1) then
          luasnip.jump(1)
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = plugin.mapping(function(fallback)
        if plugin.visible() then
          plugin.select_prev_item()
        elseif luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
      -- ]]
    }),
    sources = plugin.config.sources({
      { name = "lazydev" },
      { name = "nvim_lsp" },
      { name = "luasnip" },
    }, {
      { name = "buffer" },
    }),
  })
end
-- ]]

-- setup language server protocol [[
local function config_lsp()
  local plugin = require("lspconfig")

  local function on_attach()
    vim.keymap.set("n", "<leader>cl", "<cmd>LspInfo<cr>", { desc = "LSP info" })
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto Definition" })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "References", nowait = true })
    vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { desc = "Goto Implementation" })
    vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { desc = "Goto T[y]pe Definition" })
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
    vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
    vim.keymap.set("i", "<c-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
    vim.keymap.set({ "n", "v" }, "<leader>cc", vim.lsp.codelens.run, { desc = "Run Codelens" })
    vim.keymap.set("n", "<leader>cC", vim.lsp.codelens.refresh, { desc = "Refresh & Display Codelens" })
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
  end

  local servers = {
    "eslint",
    "gopls",
    "lua_ls",
    "nil_ls",
    "rust_analyzer",
  }
  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  for _, lsp in ipairs(servers) do
    plugin[lsp].setup({ capabilities = capabilities, on_attach = on_attach })
  end

  plugin.volar.setup({
    capabilities = capabilities,
    filetypes = {
      "typescript",
      "javascript",
      "javascriptreact",
      "typescriptreact",
      "vue",
    },
    init_options = { vue = { hybridMode = false } },
    on_attach = on_attach,
  })
end
-- ]]

local spec = {
  -- plugin manager, load first, self managed
  { "folke/lazy.nvim", tag = lazy_version },
  -- colorscheme
  {
    "tinted-theming/base16-vim",
    commit = "dfc1d89",
    priority = 100, -- it's recommended to set this to a high number for colorschemes
  },
  -- icon provider
  { "nvim-tree/nvim-web-devicons", commit = "56f17de" },
  -- status line, bottom
  {
    "nvim-lualine/lualine.nvim",
    commit = "b431d22",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        -- prefer ASCII [[
        section_separators = "",
        component_separators = "",
        -- ]]
      },
    },
  },
  -- buffer line, top
  { "akinsho/bufferline.nvim", commit = "0b2fd86", opts = {} },
  -- lua development
  { "Bilal2453/luvit-meta", commit = "ce76f6f" },
  {
    "folke/lazydev.nvim",
    commit = "491452c",
    ft = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  -- comments
  { "folke/ts-comments.nvim", commit = "98d7d4d", event = "VeryLazy", opts = {} },
  -- todo comments
  {
    "folke/todo-comments.nvim",
    commit = "ae0a2af",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  -- code parser
  {
    "nvim-treesitter/nvim-treesitter",
    commit = "9d2acd4",
    opts = {
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
        -- noice dependencies
        "bash",
        "regex",
        -- others
        "rust",
      },
    },
  },
  -- language server protocol
  { "neovim/nvim-lspconfig", commit = "d3f169f", config = config_lsp },
  -- auto formatter
  {
    "stevearc/conform.nvim",
    commit = "40d4e98",
    opts = {
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
    },
  },
  -- completion framework [[
  -- snippet engine
  { "L3MON4D3/LuaSnip", commit = "e808bee" },
  -- language server protocol source
  { "hrsh7th/cmp-nvim-lsp", commit = "39e2eda" },
  -- show source of text on the menu
  { "onsails/lspkind.nvim", commit = "59c3f41" },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "hrsh7th/cmp-nvim-lsp",
      "onsails/lspkind.nvim",
    },
    config = config_cmp,
  },
  -- ]]
  -- library of independent Lua modules
  {
    "echasnovski/mini.nvim",
    commit = "a535342",
    config = function()
      -- general
      require("mini.basics").setup({})
      require("mini.bracketed").setup({})
      require("mini.pick").setup({})
      -- editing
      require("mini.ai").setup({})
      require("mini.operators").setup({})
      require("mini.pairs").setup({})
      require("mini.surround").setup({
        mappings = {
          add = "gsa",
          delete = "gsd",
          find = "gsf",
          find_left = "gsF",
          highlight = "gsh",
          replace = "gsr",
          suffix_last = "l",
          suffix_next = "n",
          update_n_lines = "gsn",
        },
      })
    end,
    keys = {
      { "<leader>fb", "<cmd>Pick buffers<cr>", desc = "Pick buffers" },
      { "<leader>ff", "<cmd>Pick files<cr>", desc = "Pick files" },
      { "<leader>sg", "<cmd>Pick grep_live<cr>", desc = "Live grep" },
    },
  },
  -- navigate
  {
    "folke/flash.nvim",
    commit = "34c7be1",
    event = "VeryLazy",
    opts = { label = { rainbow = { enabled = true } } },
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function() require("flash").jump() end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function() require("flash").treesitter() end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function() require("flash").remote() end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function() require("flash").treesitter_search() end,
        desc = "Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function() require("flash").toggle() end,
        desc = "Toggle Flash Search",
      },
    },
  },
  -- language server protocol progress [[
  { "j-hui/fidget.nvim", commit = "d855eed", opts = {} },
  -- ]]
  -- explorer [[
  { "nvim-lua/plenary.nvim", commit = "2d9b061" },
  { "MunifTanjim/nui.nvim", commit = "b58e2bf" },
  {
    "nvim-neo-tree/neo-tree.nvim",
    commit = "a77af2e",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      close_if_last_window = true,
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
      },
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Neotree" },
    },
  },
  -- ]]
  -- gitsigns
  {
    "lewis6991/gitsigns.nvim",
    commit = "8639036",
    opts = {
      signs = {
        add = { text = " +" },
        change = { text = " ~" },
        delete = { text = " _" },
        topdelete = { text = " ‾" },
        changedelete = { text = " ~" },
        untracked = { text = " ┆" },
      },
      signs_staged = {
        add = { text = "S+" },
        change = { text = "S~" },
        delete = { text = "S_" },
        topdelete = { text = "S‾" },
        changedelete = { text = "S~" },
        untracked = { text = "S┆" },
      },
      -- https://github.com/LazyVim/LazyVim/blob/13a4a84e3485a36e64055365665a45dc82b6bf71/lua/lazyvim/plugins/editor.lua
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc }) end

        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev Hunk")
        map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghB", function() gs.blame() end, "Blame Buffer")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },
  -- indent guidelines
  { "lukas-reineke/indent-blankline.nvim", commit = "e7a4442", main = "ibl", opts = {} },
  -- replace UI for messages, cmdline, and popup menu [[
  { "rcarriga/nvim-notify", commit = "fbef5d3" },
  {
    "folke/noice.nvim",
    commit = "df448c6",
    dependencies = { "rcarriga/nvim-notify" },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        lsp_doc_border = false,
      },
    },
  },
  -- ]]
  -- keymaps
  {
    "folke/which-key.nvim",
    commit = "8badb35",
    event = "VeryLazy",
    opts = {
      spec = {
        {
          mode = { "n", "v" },
          { "<leader><tab>", group = "tabs" },
          { "<leader>c", group = "code" },
          { "<leader>f", group = "file/find" },
          { "<leader>g", group = "git" },
          { "<leader>gh", group = "hunks" },
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
      },
    },
  },
}

require("lazy").setup({ spec = spec })

-- appearance options [[
vim.opt.termguicolors = true
vim.cmd([[colorscheme base16-irblack]])

vim.api.nvim_set_hl(0, "MiniPickBorder", { link = "FloatBorder" })
vim.api.nvim_set_hl(0, "MiniPickIconDirectory", { link = "Directory" })
vim.api.nvim_set_hl(0, "MiniPickMatchCurrent", { link = "CursorLine" })
vim.api.nvim_set_hl(0, "MiniPickMatchMarked", { link = "Visual" })
vim.api.nvim_set_hl(0, "MiniPickNormal", { link = "NormalFloat" })
vim.api.nvim_set_hl(0, "MiniPickNormal", { link = "Normal" })
vim.api.nvim_set_hl(0, "MiniPickPreviewLine", { link = "CursorLine" })
vim.api.nvim_set_hl(0, "MiniPickPreviewRegion", { link = "IncSearch" })
-- ]]

-- https://github.com/LazyVim/LazyVim/blob/13a4a84e3485a36e64055365665a45dc82b6bf71/lua/lazyvim/config/keymaps.lua
-- keymaps [[

-- buffers
-- https://github.com/LazyVim/LazyVim/blob/13a4a84e3485a36e64055365665a45dc82b6bf71/lua/lazyvim/util/ui.lua#L228
local function bufremove(buf)
  buf = buf or 0
  buf = buf == 0 and vim.api.nvim_get_current_buf() or buf

  if vim.bo.modified then
    local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
    if choice == 0 or choice == 3 then -- 0 for <Esc>/<C-c> and 3 for Cancel
      return
    end
    if choice == 1 then -- Yes
      vim.cmd.write()
    end
  end

  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.api.nvim_win_call(win, function()
      if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf then return end
      -- Try using alternate buffer
      local alt = vim.fn.bufnr("#")
      if alt ~= buf and vim.fn.buflisted(alt) == 1 then
        vim.api.nvim_win_set_buf(win, alt)
        return
      end

      -- Try using previous buffer
      local has_previous = pcall(vim.cmd, "bprevious")
      if has_previous and buf ~= vim.api.nvim_win_get_buf(win) then return end

      -- Create new listed buffer
      local new_buf = vim.api.nvim_create_buf(true, false)
      vim.api.nvim_win_set_buf(win, new_buf)
    end)
  end
  if vim.api.nvim_buf_is_valid(buf) then pcall(vim.cmd, "bdelete! " .. buf) end
end
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>bd", bufremove, { desc = "Delete Buffer" })
vim.keymap.set("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- clear search with <esc>
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n [[
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
-- ]]

-- better indent
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- lazy
vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- new file
vim.keymap.set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- diagnostics/quickfix
vim.keymap.set("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
vim.keymap.set("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

-- diagnostic
-- https://github.com/LazyVim/LazyVim/blob/13a4a84e3485a36e64055365665a45dc82b6bf71/lua/lazyvim/config/keymaps.lua#L100
local function diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function() go({ severity = severity }) end
end
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- quit
vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- highlights under cursor
vim.keymap.set("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
vim.keymap.set("n", "<leader>uI", "<cmd>InspectTree<cr>", { desc = "Inspect Tree" })

-- terminal mappings
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
vim.keymap.set("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })
vim.keymap.set("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
vim.keymap.set("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- windows
vim.keymap.set("n", "<leader>w", "<c-w>", { desc = "Windows", remap = true })
vim.keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

-- tabs
vim.keymap.set("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
vim.keymap.set("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
vim.keymap.set("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
vim.keymap.set("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
-- ]]
