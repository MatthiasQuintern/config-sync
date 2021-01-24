syntax on

set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab 	" converts tabs to spaces
set smartindent
set nu 		" line numbers
set nowrap              " do not break line
set undodir=~/.vim/undodir 	" directory to store backups to undo
set undofile			" one file per edited file
set incsearch			" show results while searching

" shortcuts to change between splits without C-w
map <C-h> <C-w>h
map <C-l> <C-w>l
map <C-k> <C-w>k
map <C-j> <C-w>j

" copy paste from system clipboard
vnoremap <C-c> "+y
map <C-v> "+P

call plug#begin('~/.vim/plugged')

" Plug 'morhetz/gruvbox'  " color scheme

call plug#end()
