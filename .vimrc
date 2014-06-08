" Pathogen
execute pathogen#infect()

" My plugins include:
"
"   vim-coffee-script
"   vim-indent-guides
"   vim-less
"   vim-stylus

filetype plugin indent on

set nocompatible
set ruler
set mouse=a
set noerrorbells
set listchars=tab:>-,trail:-
set number
set numberwidth=3

set autoindent
set tabstop=2
set shiftwidth=2
set expandtab

" Indentation guidelines (vim-indent-guides)
colorscheme default
hi IndentGuidesOdd ctermbg=0
hi IndentGuidesEven ctermbg=234
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 0
let g:indent_guides_enable_on_vim_startup = 1

" Wildmenu
if has("wildmenu")
    set wildignore+=*.a,*.o,*.pyc
    set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
    set wildignore+=.DS_Store,.git,.hg,.svn
    set wildignore+=*~,*.swp,*.tmp
    set wildmenu
    set wildmode=longest,list,full
endif

" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
