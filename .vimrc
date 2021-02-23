syntax on

set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab 	" converts tabs to spaces
set smartindent
set number relativenumber " hybrid line numbers
set nowrap              " do not break line
set undodir=~/.vim/undodir 	" directory to store backups to undo
set undofile			" one file per edited file
set incsearch			" show results while searching
set formatoptions-=cro  "auto kommentieren aus
set path+=**        " erlaubt rekursive suche nach dateien, für autocomplete
set wildmenu        " zeigt bei :find die dateien an

" toggle line wrap
map <leader>w :call ToggleWrap()<CR>
fun! ToggleWrap()
    if &wrap == "nowrap"
        set wrap
    else
        set nowrap
    endif
endfun


filetype plugin on

"
" ALLGEMEINE MAPPINGS:
"
" set leader to space
let mapleader="\<Space>"

" make splits open right and bottom
set splitbelow splitright
" shortcuts to change between splits without C-w
map <C-h> <C-w>h
map <C-l> <C-w>l
map <C-k> <C-w>k
map <C-j> <C-w>j

" hjkl mit crt im insert mode
inoremap <C-h> <left>
inoremap <C-j> <down>
inoremap <C-k> <up>
inoremap <C-l> <right>

" normal mode with double i
inoremap jj <Esc>

" copy paste from system clipboard
vnoremap <C-c> "+y
map <C-v> "+P

" Rechtschreibprüfung
map <F6> :setlocal spell! spelllang=de<CR>
map <F7> :setlocal spell! spelllang=en_us<CR>

"
" PLUGINS:
"
call plug#begin('~/.vim/plugged')
    Plug 'lervag/vimtex'
    " Plug 'xuhdev/vim-latex-live-preview'
    " Plug 'morhetz/gruvbox'  " color scheme
    Plug 'tpope/vim-surround' 
    Plug 'tpope/vim-commentary'
call plug#end()


"
" KLAMMERN SCHLIESSEN:
"
autocmd FileType tex,bib,python,html,java,vim inoremap ' ''<left>
autocmd FileType tex,bib,python,html,java,vim inoremap " ""<left>
autocmd FileType tex,bib,python,html,java,vim inoremap ( ()<left>
autocmd FileType tex,bib,python,html,java,vim inoremap [ []<left>
autocmd FileType tex,bib,python,html,java,vim inoremap { {}<left>
autocmd FileType tex,bib,python,html,java,vim inoremap < <><left>

autocmd FileType tex inoremap $ $$<left>

" springt zum nächsten <++> tag
autocmd FileType html,tex inoremap üü <Esc>/<++><Enter>"_c4l

"
" LEERE DOKUMENTE:
"
nnoremap <leader>html :-1read $HOME/.vim/vorlage.html<CR>gg
nnoremap <leader>tex :-1read $HOME/.vim/vorlage.tex<CR>gg

"
" TEX: 
"
" Compiling- Basic: <leader>pb - Bibtex: <leader>pp
autocmd FileType tex nnoremap <leader>pb :! pdflatex %<CR>
autocmd FileType tex nnoremap <leader>pp :! pdflatex % && biber %:p && pdflatex % && pdflatex %<CR>
autocmd FileType tex nnoremap <leader>d :! zathura %:r.pdf<CR>

" " Live Preview
" let g:livepreview_previewer = 'zathura'
" let g:livepreview_use_biber = 1

" vimtex
let g:vimtex_view_method = 'zathura'

" Umgebungen
autocmd FileType tex inoremap ;eq \begin{equation}<CR><CR>\label{eq:<++>}<Enter>\end{equation}<Enter><++><Esc>kkki<Tab>
autocmd FileType tex inoremap ;fig \begin{figure}[h]<CR>\centering<Enter>\includegraphics[width=\textwidth]{<++>}<CR>\caption{<++>}<CR>\label{fig:<++>}<Enter>\end{figure}<CR><++><Esc>4kf=a 
autocmd FileType tex inoremap ;tab \begin{table}[]<CR>\centering<CR>\begin{tabular}{<++>}<CR>\hline<CR><++><CR>\end{tabular}<CR>\caption{<++>}<CR>\label{tab:<++>}<CR>\end{table}<CR><++><Esc>9k/[<CR>a

" erstellt eine Tex environment (begin end) mit dem argument
fun! TexEnv()
    let env = input("Name der Tex-Umgebung: ")
    return "\\begin{".env."}\r\\end{".env."}\r\<C-o>k\<C-o>O"
endfun

" shortcut für die funktion
autocmd FileType tex inoremap <expr> ;bg TexEnv()

" \ Sachen
autocmd FileType tex inoremap ;tf \textbf{} <++><Esc>T{i
autocmd FileType tex inoremap ;ti \textit{} <++><Esc>T{i
autocmd FileType tex inoremap ;tn \textrm{}<++><Esc>T{i
autocmd FileType tex inoremap ;sec \section{}<CR><++><Esc>k/{<CR>a
autocmd FileType tex inoremap ;ssec \subsection{}<CR><++><Esc>k/{<CR>a
autocmd FileType tex inoremap ;sssec \subsubsection{}<CR><++><Esc>k/{<CR>a
autocmd FileType tex inoremap ;r \ref{} <++><Esc>T{i
autocmd FileType tex inoremap ;c \cite{} <++><Esc>T{i
" Math mode
autocmd FileType tex inoremap ** \cdot 
autocmd FileType tex inoremap __ _{}<++><Esc>T{i
autocmd FileType tex inoremap ;fr \frac{}{<++>} <++><Esc>T{2hi

 

"
" PYTHON:
"
autocmd FileType python noremap ;w <Esc>:w<CR>
autocmd FileType python noremap ;wr <ESC>:w<CR>:! python3 %


"
" HTML:
"
autocmd FileType html inoremap ;i <em></em><Space><++><Esc>FeT>i
autocmd FileType html inoremap ;b <b></b><Space><++><Esc>FbT>i
autocmd FileType html inoremap ;p <p></p><Enter><Enter><++><Esc>2kf/T>i
