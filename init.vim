" Basic settings
set number
syntax on
set showmatch

" Plugin manager (vim-plug)
call plug#begin('~/.config/nvim/plugged')

" General plugins
Plug 'neovim/nvim-lspconfig'              " LSP configuration
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " Syntax highlighting
Plug 'udalov/kotlin-vim'                  " Kotlin support
Plug 'othree/xml.vim'                     " XML support
Plug 'hrsh7th/nvim-cmp'                   " Autocompletion
Plug 'hrsh7th/cmp-nvim-lsp'               " LSP source for nvim-cmp
Plug 'L3MON4D3/LuaSnip'                   " Snippets
Plug 'saadparwaiz1/cmp_luasnip'           " Luasnip source for nvim-cmp

" Dart and Flutter plugins
Plug 'dart-lang/dart-vim-plugin'          " Dart syntax highlighting
Plug 'nvim-lua/plenary.nvim'
Plug 'stevearc/dressing.nvim' " optional for vim.ui.select
Plug 'nvim-flutter/flutter-tools.nvim'

call plug#end()

" Treesitter configuration
lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "kotlin", "xml", "lua", "dart" }, -- Add 'dart' to the list
  highlight = { enable = true },
  indent = { enable = true },
}
EOF

" LSP and autocompletion setup
lua << EOF
local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')

local capabilities = cmp_nvim_lsp.default_capabilities()

-- Kotlin LSP
lspconfig.kotlin_language_server.setup {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    local opts = { noremap=true, silent=true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)

    -- Code actions
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

    -- Rename
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)

    -- Diagnostics
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  end
}

-- XML (Lemminx) LSP
lspconfig.lemminx.setup {
  capabilities = capabilities,
}
EOF

" Flutter
lua << EOF
  require("flutter-tools").setup {} -- use defaults
EOF

" Autocompletion setup
lua << EOF
local cmp = require('cmp')
cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<CR>']  = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }
}
EOF
