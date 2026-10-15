-- Add Mason bin directory to PATH so Neovim can find installed language servers
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH

-- Neovim Settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = false
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

enable_transparency()
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = enable_transparency,
})

-- Bootstrap lazy.nvim (Plugin Manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
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
      })
    end,
  },
  { "neovim/nvim-lspconfig" },

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
})

-- LSP keymaps (Neovim already provides K, grn, gra, grr, gri, [d, ]d)
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set({ "n", "v" }, "<leader>f", vim.lsp.buf.format, { desc = "Format" })

-- Configure LSP Clients
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local servers = { "ts_ls", "eslint", "html", "cssls", "tailwindcss", "clangd", "jdtls", "pyright", "ruff" }

for _, lsp in ipairs(servers) do
  if vim.lsp.config then
    vim.lsp.config(lsp, {
      capabilities = capabilities,
    })
    vim.lsp.enable(lsp)
  else
    require("lspconfig")[lsp].setup({
      capabilities = capabilities,
    })
  end
end

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
