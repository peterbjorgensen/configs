filetype plugin on
filetype indent on
syntax on
source /usr/share/vim/plugin/comments.vim
colorscheme darkZ
set guifont=Monospace\ 8
set hlsearch
set guioptions-=T
set directory=/home/peter/.vim/swp,.,/tmp,/var/tmp

let g:mapleader = '½'
let g:maplocalleader = '½'

set grepprg=egrep\ -nH\ $*


let g:tex_flavor='latex'
let g:Tex_FormatDependency = 'pdf'
let g:Tex_Leader = '<'
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_CompileRule_pdf = 'make figs && make figs && latexmk -pdf $*'
"let g:Tex_CompileRule_pdf = 'pdflatex --synctex=1 -interaction=nonstopmode $*'
"let g:Tex_MultipleCompileFormats = 'pdf'
"let g:Tex_ViewRule_pdf = 'evince'
let g:Tex_GotoError = 0
let g:Tex_UseMakefile = 0

"set spell
"setlocal spell spelllang=en_us
"setlocal spell spelllang=da
let spell_auto_type="tex,doc,mail"

nnoremap æ :cprev<CR>
nnoremap ø :cnext<CR>
nnoremap å :cclose<CR>
noremap <C-q> <Esc>:confirm bd<CR>

"minibufexplorer settings
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplUseSingleClick = 1
let g:miniBufExplModSelTarget = 1 
"let g:miniBufExplForceSyntaxEnable = 1
let g:miniBufExplTabWrap = 1
"hi MBEChanged guibg=white guifg=red ctermbg=darkblue 
"hi MBENormal  guibg=white guifg=black ctermbg=darkblue
"hi MBEVisibleNormal guibg=darkblue guifg=blue ctermbg=darkblue
"hi MBEVisibleChanged guibg=darkblue guifg=red ctermbg=darkblue 
hi MBEChanged guifg=red ctermbg=darkblue 
hi MBEVisibleNormal guifg=blue ctermbg=darkblue
hi MBEVisibleChanged guifg=red ctermbg=darkblue 

set wildmenu "better menu completion
set wildmode=list:longest
set tabstop=4
"au setlocal expandtab "dont use tabs
au BufRead,BufNewFile *.py setlocal setlocal expandtab
set smartindent
set smartcase
set shiftwidth=4
set scrolloff=4

"supertab completion
let g:SuperTabDefaultCompletionType = "context"
"let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
let g:pydiction_location = '/usr/share/pydiction/complete-dict'
"let g:SuperTabLongestHighlight=1
set completeopt=menu,longest


"more info for statusline
set laststatus=2
if has("statusline")
 set statusline=%<%f\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ %h%m%r%=%{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"]\ \"}%k\ %-14.(%l,%c%V%)\ %P
endif

if has("gui_running")
else
    "better highlighting for spell checker in console vim
    highlight clear SpellBad
    highlight SpellBad term=standout ctermfg=1 term=underline cterm=underline
    highlight clear SpellCap
    highlight SpellCap term=underline cterm=underline
    highlight clear SpellRare
    highlight SpellRare term=underline cterm=underline
    highlight clear SpellLocal
    highlight SpellLocal term=underline cterm=underline
endif

"ctags
au BufWritePost *.cpp,*.h,*.c,*.rl,*.def call system("ctags -a  -f ~/.vim/tags/local/ctags --extra=+q --fields=+iaS --c++kinds=+pl -I" . expand("%:p"))
au BufWritePost *.rb call system("ctags -a -f ~/.vim/tags/local/rbtags --extra=+q " . expand("%:p"))
au BufWritePost *.py call system("ctags -a -f ~/.vim/tags/local/pytags --extra=+q " . expand("%:p"))
au BufWritePost *.java call system("ctags -a -f ~/.vim/tags/local/javatags --extra=+q " . expand("%:p"))

au BufRead,BufNewFile *.rb setlocal tags+=~/.vim/tags/local/rbtags,~/.vim/tags/linux/rbtags
au BufRead,BufNewFile *.cpp,*.h,*.c setlocal tags+=~/.vim/tags/local/ctags,~/.vim/tags/linux/ctags
au BufRead,BufNewFile *.rl,*.def setlocal tags+=~/.vim/tags/local/ctags,~/.vim/tags/linux/ctags
au BufRead,BufNewFile *.py setlocal tags+=~/.vim/tags/local/pytags,~/.vim/tags/linux/pytags
au BufRead,BufNewFile *.java setlocal tags+=~/.vim/tags/local/javatags,~/.vim/tags/linux/javatags

set tags+=./.tags;${HOME}

"backup dir
set backupdir=~/.vim/backup
