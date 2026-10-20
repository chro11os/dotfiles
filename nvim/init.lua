-- Neovim Settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Transparent Background Configuration
local function enable_transparency()
  local hl_groups = {
    "Normal", "NormalFloat", "NormalNC", "SignColumn",
    "StatusLine", "StatusLineNC", "EndOfBuffer",
    "TabLine", "TabLineFill", "TabLineSel",
    "LineNr", "CursorLineNr", "Folded", "FoldColumn",
  }
  for _, group in ipairs(hl_groups) do
    vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
  end
end

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = enable_transparency,
})

-- Bootstrap lazy.nvim (Plugin Manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup plugins
require("lazy").setup({
  -- Mason Package Manager for LSPs
  -- (mason-lspconfig also runs vim.lsp.enable on installed servers)
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      { "williamboman/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "ts_ls",        -- TypeScript, JavaScript, React (JSX/TSX)
        "eslint",       -- Linting for JS / TS / React
        "html",         -- HTML
        "cssls",        -- CSS
        "tailwindcss",  -- Tailwind CSS
        "clangd",       -- C and C++
        "jdtls",        -- Java
        "pyright",      -- Python LSP
        "ruff",         -- Python linter + formatter
      },
    },
  },

  -- Autocompletion Engine & Sources
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "saadparwaiz1/cmp_luasnip" },
  { "L3MON4D3/LuaSnip" },

  -- vim-airline Statusline
  {
    "vim-airline/vim-airline",
    dependencies = { "vim-airline/vim-airline-themes" },
    config = function()
      vim.g.airline_powerline_fonts = 1
      vim.g.airline_theme = 'base16_monokai'
      vim.g.airline_left_sep = ''
      vim.g.airline_left_alt_sep = ''
      vim.g.airline_right_sep = ''
      vim.g.airline_right_alt_sep = ''
    end,
  },

  -- Tree-sitter for Rich Syntax Highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup({})
      local parsers = { "javascript", "typescript", "tsx", "html", "css", "c", "cpp", "java", "lua", "python", "markdown", "markdown_inline" }
      ts.install(parsers)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = parsers,
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },

  -- Monokai Pro Editor Colorscheme
  {
    "loctvl842/monokai-pro.nvim",
    priority = 1000,
    config = function()
      require("monokai-pro").setup({
        filter = "classic", -- options: classic, octagon, pro, machine, ristretto, spectrum
      })
    end,
  },

  -- Fuzzy Finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep in project" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Find help" },
    },
  },

  -- File Explorer (edit the directory like a buffer)
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    },
  },

  -- Claude Code integration (selection context + diffs in Neovim)
  {
    "coder/claudecode.nvim",
    config = true,
    keys = {
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current file to Claude" },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
}, {
  rocks = { enabled = false }, -- no plugin needs luarocks
})

-- LSP keymaps (Neovim already provides K, grn, gra, grr, gri, [d, ]d)
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set({ "n", "v" }, "<leader>f", vim.lsp.buf.format, { desc = "Format" })

-- Advertise cmp completion capabilities to every LSP server
vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })

-- Configure Autocompletion (cmp)
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  }),
})

-- Apply colorscheme
vim.cmd("colorscheme monokai-pro")
