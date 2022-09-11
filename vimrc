:autocmd InsertEnter * set cul
:autocmd InsertLeave * set nocul

syntax enable
set noerrorbells
set tabstop=4 
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set autoindent

set hidden
set nobackup
set noswapfile
set nowritebackup
set nocompatible
set undofile
set undodir=~/.vim/undodir
set incsearch

set cmdheight=1
set runtimepath+=~/.vim_runtime
set encoding=utf-8
set viminfo='30
set modifiable

set number relativenumber
set nonumber norelativenumber
set number! relativenumber!

set foldmethod=indent
set foldlevel=99
set cursorline
set showmatch
set clipboard=unnamedplus
" set foldmethod=marker

" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**

filetype on
filetype plugin on
filetype plugin indent on

" split bar char fill
set fillchars+=vert:\ 

" gruvbox dark
autocmd vimenter * colorscheme gruvbox
" let g:gruvbox_contrast_dark='hard'
set bg=dark

" basics
nnoremap rl :source $HOME/.config/nvim/init.vim<CR>
nnoremap gs :Git status<CR>
nnoremap gl :diffget //3<CR>
nnoremap gh :diffget //2<CR>

" leader key remap
let mapleader = "\<space>"

" basics
nnoremap <leader>q :q<CR>
nnoremap <leader>/ :set hlsearch!<CR>
nnoremap <leader>[ <C-b>
nnoremap <leader>] <C-f>

" window mgmt, split move and resize
" <C-W><C-W> to move to next window, <C-hjkl> used in tmux
nnoremap <leader>s :split<CR>
nnoremap <leader>a :vsplit<CR>
nnoremap <leader>j <C-W><C-j>
nnoremap <leader>f :LF<CR>
nnoremap <leader>k <C-W><C-k>
nnoremap <leader>l <C-W><C-l>
nnoremap <leader>h <C-W><C-h>
nnoremap <leader>J <C-W>J
nnoremap <leader>K <C-W>K
nnoremap <leader>H <C-W>H
nnoremap <leader>L <C-W>L
nmap <leader>= :vertical resize +20<CR>
nmap <leader>- :vertical resize -20<CR>
nmap <leader>, :res -20<CR>
nmap <leader>. :res +20<CR>

nnoremap <leader>o :browse oldfiles<CR>
nnoremap <leader>u :UndotreeShow<CR>
nnoremap <leader>r :Rg<SPACE>
nnoremap <leader>t :FloatermNew --autoclose=0 cargo test -- --nocapture<CR>
nnoremap <leader>p oprintln!("{:#?}", );<ESC>hi

" inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" lnoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" COC
set updatetime=300
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" csv
cnoreabbrev csvarrange '<,'>ArrangeColumn
cnoreabbrev csvsort '<,'>Sort 1

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
" nmap <silent> [g <Plug>(coc-diagnostic-prev)
" nmap <silent> ]g <Plug>(coc-diagnostic-next)

" code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> gk :call ShowDocumentation()<CR>
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('gk', 'in')
  endif
endfunction

" Remap keys for applying codeAction to the current buffer.
" nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
" nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects, deleted

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
" nmap <silent> <C-s> <Plug>(coc-range-select)
" xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')
" Add `:Fold` command to fold current buffer.
" command! -nargs=? Fold :call     CocAction('fold', <f-args>)
" Add `:OR` command for organize imports of the current buffer.
" command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" floaterm related
let g:floaterm_width = 0.9
let g:floaterm_height = 0.9
" Set floaterm window's background to black
hi Floaterm guibg=black
" Set floating window border line color to cyan, and background to orange
hi FloatermBorder guibg=black guifg=black
" reload required

" plugin mgmt
call plug#begin()

Plug 'morhetz/gruvbox'
Plug 'jremmen/vim-ripgrep'
Plug 'tpope/vim-fugitive'
Plug 'mbbill/undotree'
Plug 'rust-lang/rust.vim'
Plug 'JuliaEditorSupport/julia-vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ptzz/lf.vim'
Plug 'voldikss/vim-floaterm'
Plug 'chrisbra/csv.vim'

call plug#end()
" You can revert the settings after the call like so:
"   filetype indent off   " Disable file-type-specific indentation
"   syntax off            " Disable syntax highlighting
