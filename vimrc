set nocompatible

" ====  Plugins ====================================================={{{

if !filereadable(expand('~').'/.vim/autoload/plug.vim')
    exec '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs 
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

if filereadable(expand('~').'/.vim/autoload/plug.vim')
    call plug#begin('~/.vim/plug')

    Plug 'scrooloose/syntastic'  "Syntax checking
    Plug 'The-NERD-Commenter'    "Commenting code
    Plug 'bling/vim-airline'     "Nice Statusline
    Plug 'kien/ctrlp.vim'        "Fuzzy file,buffer,mru,tag finder
    Plug 'majutsushi/tagbar'     "Display Tagbar for Code tags (needs exuberant ctags)
    Plug 'Gundo'                 "Undo history
    Plug 'ervandew/supertab'     "All completions with Tab
    Plug 'Shougo/neocomplcache'  "Best autocompletation
    Plug 'Shougo/neosnippet'     "Snippets
    Plug 'Shougo/neosnippet-snippets'     "Snippets
    Plug 'godlygeek/tabular'     "Tabular alignment
    Plug 'honza/vim-snippets'    "Nice snippets for for autocompletation
    "Plug 'garbas/vim-snipmate'
    Plug 'nathanaelkane/vim-indent-guides' "Indention hinting for code lines
    Plug 'jonathanfilip/vim-lucius' "Colorscheme
    "Plug 'edkolev/tmuxline.vim'  "Make tmux colors like vim statusline
    Plug 'gregsexton/MatchTag', {'for': ['html','xml']}
                                 "Match Paren for HTML tags
    Plug 'matchparenpp'          "Show matching parenline in statusline
    Plug 'tpope/vim-fugitive'    "git wrapper
    Plug 'LaTeX-Suite-aka-Vim-LaTeX', {'for': ['tex','sty']}
                                 "Latex!
    "Plug 'Yggdroot/indentLine'   "indent line

    "Util
    Plug 'MarcWeber/vim-addon-mw-utils'
    Plug 'tomtom/tlib_vim'
    Plug 'sudo.vim'              "edit file as sudo 

    "own ftplugins
    Plug 'https://github.com/hackenbergstefan/my-vimftplugins'
    

    call plug#end()
endif

" }}}
" ====  General ====================================================={{{
syntax on

if has("autocmd")
  filetype plugin on
  filetype indent on

  " completion
  set ofu=syntaxcomplete#Complete
  "filetype plugin indent on
  set completeopt=longest,menuone

  " jump to the last position when reopening a file
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

  " resize splits
  au VimResized * exe "normal! \<c-w>="

  "save folding (shouldnt run every time)
  "au BufWinLeave * mkview
  "au BufWinEnter * silent loadview

  " leave paste mode, when exit insert mode
  au InsertLeave * set nopaste
endif

" Use Unix as the standard file type
set ffs=unix,dos,mac
set encoding=utf8

set virtualedit=all
set backspace=2
" set backspace=indent,eol,start
set showcmd   " Show (partial) command in status line.
set showmatch " Show matching brackets.
set autowrite " Automatically save before commands like :next and :make
if has("mouse")
  set mouse=a " Enable mouse usage (all modes) alternativ nvc
  set mousehide
endif
set visualbell " ausgehebelt durch noerrorbells ?
set noerrorbells
set hidden
set autoread
set magic      " For regular expressions turn magic on
set splitbelow " set splitright
set autochdir

set cpoptions+=n
set showbreak=\ \ \ ↳

set wildmenu "Kommando Zeilen Vervollständigung
"set wildignore=*.dll,*.o,*.obj,*.bak,*.exe,*.pyc,*.jpg,*.gif,*.png
set wildignore=*.dll,*.o,*.obj,*.bak,*.exe,*.pyc,*.jpg,*.gif,*.png,*.aux,*.bbl,*.blg,*.fdb_latexmk,*.fls,*.idx,*.ilg,*.ind,*.nlo,*.toc,*.hi
set wildmode=list:longest

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" Set standard latex filetype to tex instead of plaintex
let g:tex_flavor = "latex"
" }}}
" ====  Scrolling  =================================================={{{

set scrolljump=5
set scrolloff=5         "Start scrolling when we're x lines away from margins
set sidescrolloff=10
set sidescroll=1
"                                                                    }}}
" ====  Search  ====================================================={{{

" highlight searches, searches begin immediately
set hlsearch
set incsearch
" case sensitiv, if a uppercase letter is contained
set smartcase
set ignorecase
"                                                                    }}}
" ====  Folding / Indenting  ========================================{{{

set foldmethod=marker
set foldmarker={{{,}}}

" indending
set autoindent
set smartindent
set shiftwidth=4 softtabstop=4 tabstop=4 expandtab
set smarttab

set list
set listchars=tab:>.,trail:…,extends:#,nbsp:. " …°⎼
set fillchars=vert:┃,diff:⎼,fold:⎼
"                                                                    }}}
" ====  Performance  ================================================{{{
set ttyfast

" for powersave, stops the blinking cursor
let &guicursor = &guicursor . ",a:blinkon0"
" Speed hack
hi NonText cterm=NONE ctermfg=NONE
" stops slow responding in large files
set synmaxcol=128
"                                                                    }}}
" ====  Line Numbering  ============================================={{{
au InsertEnter * :set nu
au InsertLeave * :set rnu
au FocusLost * :set nu
au FocusGained * :set rnu
set rnu
"                                                                    }}}
" ====  Backup / Undo  =============================================={{{

set history=1000
set undolevels=1000

" Keep undo history across sessions, by storing in file.
silent !mkdir ~/.vim/backups > /dev/null 2>&1
set undodir=~/.vim/backups
set undofile

" swap
set swapfile
set dir=/tmp " tmpfs

" no backup!
set nobackup
" backup to ~/.tmp
"set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
"set backupskip=/tmp/*,/private/tmp/*
"set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
"set writebackup
"                                                                    }}}
" ====  Design ======================================================{{{

set title
set cursorline
set nocursorcolumn " hat probleme mit acp (Popup)
set textwidth=0    " Don't wrap lines by default
set nowrap
set ruler

set showmode "show when you are in insert mode

" statusline
set laststatus=2
" default the statusline to green when entering Vim
"hi StatusLine term=reverse ctermfg=0 ctermbg=2 gui=bold,reverse


set statusline=%<%f\          " custom statusline
set stl+=[%{&ff}]             " show fileformat
set stl+=%y%m%r%=
set stl+=%-14.(%l,%c%V%)\ %P

if has("gui_running")
  " in gui
  map <S-Insert> <MiddleMouse>
  map! <S-Insert> <MiddleMouse>
  set guioptions-=T  " no toolbar
  " Use console messages instead of GUI dialogs
  set guioptions+=c

  let g:indent_guides_auto_colors = 0
  "autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=black ctermbg=none
else
  " no gui
  set t_Co=256
  set background=light
endif


" colorscheme
let g:lucius_style="dark"
let g:lucius_no_term_bg="1"
colorscheme lucius
" }}}
" ====  Keymappings ================================================={{{
" ----  General -----------------------------------------------------{{{
let mapleader=","
noremap <c-j> 8j
noremap <c-k> 8k
" }}}
" }}}
" ====  Pluginspecific Setup ========================================{{{
" ----  Tagbar ------------------------------------------------------{{{
nmap <F8> :TagbarOpenAutoClose<CR>
" }}}

" ----  Neocomplcache -----------------------------------------------{{{
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Enable heavy features.
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
"let g:neocomplcache_snippets_dir='~/.vim/plug/vim-snippets/snippets'
" }}}

" ----  NeoSnippets -------------------------------------------------{{{
" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
    \ "\<Plug>(neosnippet_expand_or_jump)"
    \: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
    \ "\<Plug>(neosnippet_expand_or_jump)"
    \: "\<TAB>"
" }}}

" ----  Supertab ----------------------------------------------------{{{
" cycle completion list from top to bottom
let g:SuperTabDefaultCompletionType = "<c-n>"
" }}}

" ----  Vim-Airline -------------------------------------------------{{{
let g:airline_powerline_fonts = 0
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
" }}}

" ----  Vim-Indent-Guidlines ----------------------------------------{{{
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 0
hi IndentGuidesOdd  guibg=red   ctermbg=234
hi IndentGuidesEven guibg=green ctermbg=237
" }}}

" ----  Vim-Latex ---------- ----------------------------------------{{{
" this should be in ~/.vim/ftplugin/tex.vim 
" read doku of Latex-Suite!
imap <C-g> <Plug>IMAP_JumpForward
nmap <C-g> <Plug>IMAP_JumpForward
" }}}
" }}}
" ====  Filetype Specific ==========================================={{{
augroup filetypedetect
  au! BufRead,BufNewFile *.sage,*.spyx,*.pyx setfiletype python
augroup END
" }}}



