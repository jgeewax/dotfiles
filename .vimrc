" Pathogen
execute pathogen#infect()

" My plugins include:
"
"   vim-angular
"   vim-coffee-script
"   vim-indent-guides
"   vim-javascript
"   vim-jsx
"   vim-less
"   vim-stylus

filetype plugin indent on

syntax on

set clipboard=unnamedplus
set nocompatible
set ruler
set mouse=a
set ttymouse=sgr
set noerrorbells
set listchars=tab:>-,trail:-
set number
set numberwidth=3

set autoindent
set tabstop=2
set shiftwidth=2
set expandtab
set tw=80

" Indentation guidelines (vim-indent-guides)
colorscheme default
hi IndentGuidesOdd ctermbg=0
hi IndentGuidesEven ctermbg=234
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 0
let g:indent_guides_enable_on_vim_startup = 1

" 80-character guideline
if exists('+colorcolumn')
    set colorcolumn=80
    hi ColorColumn ctermbg=235 guibg=#262626
endif

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

" .ng files should act like .html files
au BufReadPost *.ng set syntax=html

" .js files should work like .jsx files
let g:jsx_ext_required = 0

" Syntastic recommended settings
set statusline+=%<\ %n:%f\ %m%r%y
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
set statusline+=%=
set statusline+=%-35.(line:\ %l\ of\ %L,\ col:\ %c%V\ (%P)%)

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
"let g:syntastic_javascript_checkers = ['eslint']
