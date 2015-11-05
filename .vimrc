" vimrc
" 
" Brian Schrader
" 2015-08-10

" This configuration is based on sample vimrc files 
" and this talk at pycon https://www.youtube.com/watch?v=YhqsjUUHj6g

set autoread
set encoding=utf-8
set t_Co=256
set dictionary=/usr/share/dict/words


" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Height of the command bar
set cmdheight=2

" Autoreload vimrc config.
autocmd! bufwritepost .vimrc source % 

" Set 7 lines to the cursor - when moving vertically using j/k
set so=10

" For regular expressions turn magic on
set magic

" Better copy and paste
set pastetoggle=<F2>
set clipboard=unnamed

" Using the mouse and backspace
"set mouse=a
set bs=2

" Rebind leader key
let mapleader = ","

" Map the sort function to a key
vnoremap <Leader>s :sort<CR>

" Easier moving of blocks of code
vnoremap < <gv 
vnoremap > >gv

" Syntax highlighting
"colorscheme desert
filetype off
filetype plugin indent on
syntax on
let g:pydiction_location = '~/.vim/bundle/pydiction/complete-dict'

" Line numbers and length
set tw=79	" Terminal width
set wrap linebreak nolist
"set linebreak 
"set nolist

" History
set history=700
set undolevels=700

" Tabs vs Spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab

" Search highlighting
set hlsearch
set incsearch
set ignorecase
set smartcase

" Disable swap 
set nobackup
set nowritebackup
set noswapfile

" Show matching brackets when text indicator is over them
set showmatch

" Plugin manager
" Install plugins in .vim/bundles/plugin-name/
call pathogen#infect()

" ===============================================
" Python IDE Setup
" ===============================================

" Vim-Poweline
if !exists('g:airline_symbols')
      let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
set laststatus=2

" cntlp settings
let g:cntlp_max_height = 30
" Turn on the WiLd menu
set wildmenu
" Ignore compiled files
set wildignore=*.o,*~,*.pyc
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=*/coverage/*

" Python Folding
set nofoldenable

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Close the current buffer
map <leader>bd :Bclose<cr>

" Close all the buffers
map <leader>ba :1,1000 bd!<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove

" Opens a new tab with the current buffer's path
" Super useful wren editing files in the same directory
map <leader>te :rabedit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers 
try
    set switchbuf=useopen,usetab,newtab
    set stal=2
    catch
endtry

" Return to last edit position when opening files (You want this!)
"autocmd BufReadPost *
"if line("'\"") > 0 && line("'\"") <= line("$") |
"    exe "normal! g`\"" |
"endif

" Remember info about open buffers on close
set viminfo^=%


""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
"set laststatus=2

" Format the status line
"set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
map 0 ^

" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
    nmap <D-j> <M-j>
    nmap <D-k> <M-k>
    vmap <D-j> <M-j>
    vmap <D-k> <M-k>
endif

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
        exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction


function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
        return ''
endfunction
