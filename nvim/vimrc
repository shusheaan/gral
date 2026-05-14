" Minimal Vim config — no plugins, no errors
" Main editor is Neovim (see nvim/ directory)

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
set undofile
set undodir=~/.vim/undodir
set incsearch

set cmdheight=1
set encoding=utf-8
set modifiable

set number relativenumber
set foldmethod=indent
set foldlevel=99
set cursorline
set showmatch
set clipboard=unnamedplus

set path+=**
filetype on
filetype plugin on
filetype plugin indent on

set fillchars+=vert:\
set bg=dark

" leader key
let mapleader = "\<space>"

" basics
nnoremap <leader>q :q<CR>
nnoremap <leader>/ :set hlsearch!<CR>
nnoremap <leader>[ <C-b>
nnoremap <leader>] <C-f>

" window management
nnoremap <leader>s :split<CR>
nnoremap <leader>a :vsplit<CR>
nnoremap <leader>j <C-W><C-j>
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

" file search (built-in)
nnoremap <leader>o :browse oldfiles<CR>
nnoremap <leader>r :grep<SPACE>

" quick cursor line toggle
autocmd InsertEnter * set cul
autocmd InsertLeave * set nocul
