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

" toggle line wrap
map <leader>w :call ToggleWrap()<CR>
" folds
set foldmethod=indent

" make splits open right and bottom
set splitbelow splitright
" shortcuts to change between splits without C-w
" map <C-h> <C-w>h
" map <C-l> <C-w>l
" map <C-k> <C-w>k
" map <C-j> <C-w>j

" TABS
" nnoremap <C-I> <Tab>
" nnoremap <Tab> :tabn<Cr>
" nnoremap <C-Tab> :tabprevious<Cr>
" nnoremap <C-Tab> gT
nmap <C-l> gt
nmap <C-h> gT
nnoremap <C-t> :tabnew 

"
" SESSION
"
function! MakeSession()
  let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
  if (filewritable(b:sessiondir) != 2)
    exe 'silent !mkdir -p ' b:sessiondir
    redraw!
  endif
  let b:filename = b:sessiondir . '/session.vim'
  exe "mksession! " . b:filename
endfunction

function! LoadSession()
  let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
  let b:sessionfile = b:sessiondir . "/session.vim"
  if (filereadable(b:sessionfile))
    exe 'source ' b:sessionfile
  else
    echo "No session loaded."
  endif
endfunction
" au VimEnter * nested :call LoadSession()
au VimLeave * :call MakeSession()
nnoremap <leader>L :call LoadSession()<Cr>
nnoremap <leader>l :hi Normal ctermbg=none<Cr>
nnoremap <leader>W :call MakeSession()

" remap arrows to do nothing
noremap <Left> <nop>
noremap <Right> <nop>
noremap <Up> <nop>
noremap <Down> <nop>

inoremap <Left> <nop>
inoremap <Right> <nop>
inoremap <Up> <nop>
inoremap <Down> <nop>

" hjkl mit crt im insert mode
inoremap <C-h> <left>
inoremap <C-j> <down>
inoremap <C-k> <up>
inoremap <C-l> <right>
" hjkl mit crtl im normal mode
" nnoremap <C-h> 10<left>
nnoremap <C-j> 10<down>
nnoremap <C-k> 10<up>
" nnoremap <C-l> 10<right>

" jump to paragraph
nnoremap ü {
nnoremap ä }

" normal mode with double j
inoremap jj <Esc>

" copy paste from system clipboard
vnoremap <C-c> "+y
nnoremap <leader>v "+P

" Rechtschreibprüfung
map <F6> :setlocal spell! spelllang=de<CR>
map <F7> :setlocal spell! spelllang=en_us<CR>

"
" PLUGINS:
"
call plug#begin('~/.vim/plugged')
    Plug 'lervag/vimtex'
    Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
    Plug 'morhetz/gruvbox'
    Plug 'preservim/nerdtree'
    Plug 'neoclide/coc.nvim', { 'branch' : 'release' }
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
call plug#end()


" colorscheme gruvbox
set background=dark 
let g:gruvbox_transparent_bg='1'
autocmd VimEnter * hi Normal ctermbg=none
colorscheme gruvbox
hi Normal ctermbg=none


"
" NERDTREE
"
nnoremap <leader>n :NERDTreeToggle<CR>


" Source the cocrc file
source ~/.vim/cocrc.vim

"
" SANTASTIC
"
" execute pathogen#infect()
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1 " Auto-Öffne/Schließe die Liste wenn fehler detektiert werden. Sonst: :Errors
" let g:syntastic_loc_list_height = 5
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0

" let g:syntastic_cpp_compiler_options = "-std=c++20"

"
" KLAMMERN SCHLIESSEN:
"
autocmd FileType cpp,hpp,tex,bib,python,html,java,vim inoremap ' ''<left>
autocmd FileType cpp,hpp,tex,bib,python,html,java,vim inoremap " ""<left>
autocmd FileType cpp,hpp,tex,bib,python,html,java,vim inoremap ( ()<left>
autocmd FileType cpp,hpp,tex,bib,python,html,java,vim inoremap [ []<left>
autocmd FileType cpp,hpp,tex,bib,python,html,java,vim inoremap { {}<left>
autocmd FileType tex,bib,html,java,vim inoremap < <><left>

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
autocmd FileType tex nnoremap <leader>d :!! zathura %:r.pdf &<CR>

" " Live Preview
let g:livepreview_previewer = 'zathura'
let g:livepreview_use_biber = 1

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
" Umlaute
autocmd FileType html inoremap ü &uuml;
autocmd FileType html inoremap Ü &Uuml;
autocmd FileType html inoremap ä &auml;
autocmd FileType html inoremap Ä &Auml;
autocmd FileType html inoremap ö &ouml;
autocmd FileType html inoremap Ö &Ouml;
autocmd FileType html inoremap € &euro;
autocmd FileType html inoremap ß &szlig;

"
" C/C++
"
autocmd FileType cpp imap ö {
autocmd FileType cpp imap Ö }
autocmd FileType cpp imap ä [
autocmd FileType cpp imap Ä ]

function! SplitHeader()
    " check which filetype and then open header/source in vsplit
    if (expand("%:e") == "cpp")
        execute "vsplit %:r.hpp"
    elseif (expand("%:e") == "c")
        execute "vsplit %:r.h"
    elseif (expand("%:e") == "hpp")
        execute "vsplit %:r.cpp"
        :exe "normal \<c-w>r"
    elseif (expand("%:e") == "h")
        execute "vsplit %:r.c"
        :exe "normal \<c-w>r"
    endif
endfunction

" autocmd FileType c,cpp call SplitHeader()
nnoremap <leader>h :call SplitHeader()<Cr>
autocmd BufEnter *.tpp :setlocal filetype=cpp
