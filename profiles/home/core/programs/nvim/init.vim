let $PAGER=''

set termguicolors
set noswapfile
set nobackup
set mouse=a
set rnu
set nu
set numberwidth=2
set tabstop=4
set shiftwidth=4
set colorcolumn=72
set completeopt+=menuone
set completeopt+=noselect
set shortmess+=c
set omnifunc=v:lua.vim.lsp.omnifunc

inoremap lñ <ESC>
let mapleader = " "
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'

colorscheme jellybeans
let g:jellybeans_use_term_italics = 1
set noshowmode
let g:lightline = { 'colorscheme': 'jellybeans' }

lua << END
    lsp = require 'lspconfig'
    lsp.rnix.setup{}
    lsp.rust_analyzer.setup{}
END

let g:tidal_target = "terminal"
