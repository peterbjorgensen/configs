filetype plugin on
filetype indent on
syntax on
source /usr/share/vimfiles/plugin/comments.vim
colorscheme darkZ
if hostname() == "archpad" "smaller font for laptop
	set guifont=Monospace\ 8
endif
set hlsearch
set guioptions-=m
set guioptions-=T
set directory=/home/peter/.vim/swp,.,/tmp,/var/tmp
set backupdir=~/.vim/backup "backup dir
set incsearch "start searching as you type
set showcmd "show the number of bytes marked in visual mode

let g:mapleader = '½'
let g:maplocalleader = '½'

"set spell
let spell_auto_type="tex,doc,mail"

"General mappings
nnoremap æ :cprev<CR>
nnoremap ø :cnext<CR>
nnoremap å :cclose<CR>
noremap <C-q> <Esc>:confirm bd<CR>
"alt-a decrease number under cursor
nnoremap ª :normal! <C-x><CR>
nnoremap á :normal! <C-x><CR>
"alt-g
noremap ŋ  
noremap ç 

"minibufexplorer settings
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplUseSingleClick = 1
let g:miniBufExplModSelTarget = 1 
"let g:miniBufExplForceSyntaxEnable = 1
let g:miniBufExplTabWrap = 1
hi MBEChanged guifg=red ctermbg=darkblue 
hi MBEVisibleNormal guifg=blue ctermbg=darkblue
hi MBEVisibleChanged guifg=red ctermbg=darkblue 

set wildmenu "better menu completion
set wildmode=list:longest
set tabstop=4
set smartindent
set ignorecase
set smartcase "Dont ignorecase when upper case is used
set shiftwidth=4
set scrolloff=4

"supertab completion
"let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
"let g:SuperTabLongestHighlight=1
set completeopt=menu,longest


"more info for statusline
set laststatus=2
if has("statusline")
 set statusline=%<%f\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ %h%m%r%=%{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"]\ \"}%k\ %-14.(%l,%c%V%)\ %P
endif

if has("gui_running")
	set columns=81
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

"Quckfix window size
au FileType qf call AdjustWindowHeight(3, 8)
function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

"""""""""""""""""""""""""
""""""""Python specific
""""""""""""""""""""""""
autocmd FileType python call Autocmd_Python()

let g:pydiction_location = '/usr/share/pydiction/complete-dict'

function! Autocmd_Python()
	setlocal expandtab
	source /usr/share/vim/plugin/ropevim.vim
	"ropevim settings
	let g:ropevim_codeassist_maxfixes=10
	let g:ropevim_guess_project=1
	let g:ropevim_vim_completion=1
	let g:ropevim_enable_autoimport=1
	let g:ropevim_extended_complete=1
endfunction

function! CustomCodeAssistInsertMode()
    call RopeCodeAssistInsertMode()
    if pumvisible()
        return "\<C-L>\<Down>"
    else
        return ''
    endif
endfunction

function! TabWrapperComplete()
    let cursyn = synID(line('.'), col('.') - 1, 1)
    if pumvisible()
        return "\<C-Y>"
    endif
    if strpart(getline('.'), 0, col('.')-1) =~ '^\s*$' || cursyn != 0
        return "\<Tab>"
    else
        return "\<C-R>=CustomCodeAssistInsertMode()\<CR>"
    endif
endfunction

"""""""""""""""""""""""""
"""""""" LATEX options
"""""""""""""""""""""""""
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

autocmd BufRead,BufNewFile	*.tex	setlocal filetype=tex
autocmd BufEnter main.tex setlocal filetype=tex
autocmd BufReadPost main.aux setlocal nobuflisted
autocmd BufReadPost main.log setlocal nobuflisted

autocmd FileType tex call Autocmd_Tex()
function Autocmd_Tex()
	set fileencoding=latin1
	setlocal spell spelllang=da
	setlocal textwidth=80
	nmap <F3> <Leader>ll<CR>
	nmap <F4> :call Tex_SynctexSearch()<CR>
	call IMAP('HSI', '\SI{<++>}{<++>}<++>', 'tex')
	call IMAP('HSS', '_|<++>|<++>','tex')
	call IMAP('||', '|<++>|<++>','tex')
endfunction

"environment macros
let g:Tex_PromptedEnvironments = "flalign,flalign*,figure,minipage,table,tabular,enumerate,itemize"
let g:Tex_Env_figure = "\
\\begin{figure}[htbp]\<CR>\
	\\centering\\includegraphics[width=<++>\\textwidth]{pics/<++>}\<CR>\
	\\caption{<++>}\<CR>\
	\\label{fig:<++>}\<CR>\
\\end{figure}\<CR><++>"
let g:Tex_Env_minipage = "\
\\begin{figure}[htbp]\<CR>\
    \\centering\<CR>\
    \\begin{minipage}[c]{0.47\\textwidth}\<CR>\
		\\centering\<CR>\
		\\includegraphics[width=1\\textwidth]{pics/<++>}\<CR>\
        \\caption{<++>}\<CR>\
        \\label{fig:<++>}\<CR>\
	\\end{minipage}\\hfill\<CR>\
	\\begin{minipage}[c]{0.47\\textwidth}\<CR>\
		\\centering\<CR>\
		\\includegraphics[width=1\\textwidth]{pics/<++>}\<CR>\
        \\caption{<++>}\<CR>\
		\\label{fig:<++>}\<CR>\
    \\end{minipage}\<CR>\
\\end{figure}\<CR><++>"

function! Tex_SynctexSearch()
    if &ft != 'tex'
        echo "calling Tex_SynctexSearch from a non-tex file"
        return
    end

    let curd = getcwd()
    let xpos = col('.')
    let ypos = line('.')

    if exists('b:fragmentFile')
        let mainfname = expand('%:p:t')
        call Tex_CD(expand('%:p:h'))
    else
        let mainfname = Tex_GetMainFileName(':p:t')
        call Tex_CD(Tex_GetMainFileName(':p:h'))
    end

    let targetfile = expand('%')
    let pdffile = substitute(mainfname,'.tex','.pdf','')

    let iopt = '"' . ypos . ':' . xpos . ':' . targetfile . '"'
    let xopt = shellescape("echo %{page+1}:%{h}:%{v}:%{width}:%{height}",1)
    let shellline = 'synctex view -i ' . iopt . ' -o ' . pdffile . ' -x ' . xopt
    let result = system(shellline)
    let rslt = split(result,':')
    if len(rslt) == 5
        "Synctex succeed
        let page = remove(rslt,0)
        let evrectopt = '"' . get(rslt,0) . ':' . get(rslt,1) . ':' . get(rslt,2) . ':' . '1' . '"'
        echo 'SyncteX succeeded, launching evince'
        "execute 'silent ! nohup evince --use-absolute-page --page-label ' . page . ' --highlight-rect ' . evrectopt . ' ' . pdffile . ' >/dev/null &'
        execute 'silent ! nohup evince ' . pdffile . ' >/dev/null &'
	else
        "Synctex failed
        echo 'SyncteX failed, viewing without synctex'
        execute 'silent ! nohup evince ' . pdffile . ' >/dev/null &'
    end
endfunction

""""""""""""""""""""""""""""""""""""
"""""""""""""" Kaspers Ctags support
""""""""""""""""""""""""""""""""
" where is the tag file located. the semicolon makes it look in parent
" directories
autocmd Filetype c,tex map <F8> :call GenerateTagFile()<CR>
autocmd BufEnter *.c,*.tex silent :call SetTagFile()
inoremap <F6> <Esc>:call PreviewPrototype()<CR>a
inoremap ) )<C-r>=ClosingParanthesis()<CR><BS>
nnoremap T :TlistToggle<CR>
let Tlist_Compact_Format = 1
set tags+=TAGS;,tags;

function! SetTagFile()
    let l:currdir = getcwd()
    let g:tagdir = ""

    " use findfile("tags", ". getcwd(). "; ") instead
    while !filereadable("tags") && getcwd() != "/"
        cd ..
    endwhile

    if filereadable("tags")
        execute "set tags=" . getcwd() . "/tags"
        let g:tagdir = getcwd()
    endif
    
    echo "tagdir: " . g:tagdir
    execute "cd " . l:currdir
endfunction

function GenerateTagFile()
    if g:tagdir == ""
        while 1
            "call inputsave()
            let g:tagdir = input("Tag dir: ",".","dir")
            "call inputrestore()
            if isdirectory(g:tagdir) 
                break
            endif
            echo g:tagdir . " is not a directory\n"
        endwhile
    endif
    echo "ctags -R -f ". g:tagdir ."/tags --c++-kinds=+p --fields=+iaS --extra=+q " . g:tagdir
    execute "set tags=".g:tagdir."/tags"
    call system("ctags -R -f ". g:tagdir ."/tags --c++-kinds=+p --fields=+iaS --extra=+q " . g:tagdir)
endfunction

" returns 0 if function was complete and 1 else
function IsFuncComplete(str,pos)
    let l:level = 0
    let l:pos = match(a:str, "[()]", a:pos)
    
    while l:pos >= 0
        if a:str[l:pos] == '('
            let l:level = l:level + 1
        elseif a:str[l:pos] == ')'
            let l:level = l:level - 1
        endif
        if l:level == 0
            break
        endif
        let l:pos = match(a:str, "[()]", l:pos+1)
    endwhile
    return l:level
endfunction

" get the name of the current open function
function GetCurrentFunction()
    let currline = getline(".")
    let subline = strpart(currline, 0, col(".")) 
    
    " start from the cursor
    let l:pos = len(subline)
    let l:complete = 0
    
    while l:complete == 0 || l:funcstart == -1
        " match last left paranthesis before l:pos
        let l:end = match(strpart(subline,0,l:pos+1),  "([^(]*$")
        if l:end < 1
            return ""
        endif
        
        " match the last function name before the left paranthesis
        let l:funcstart = match(strpart(subline, 0,l:end+1), "[a-zA-Z][^ \t()]*[ \t]*([^(]*$")
        if l:funcstart != -1
            let l:complete = IsFuncComplete(subline, l:funcstart)
            let l:pos = l:funcstart
        else
            let l:pos = l:end - 1
            let l:complete = 1
        endif
    endwhile
    " extract function name
    let l:funcstr = matchstr(strpart(subline, 0, l:end+1),"[a-zA-Z][^ \t()]*[ \t]*([^(]*$")
    return strpart(l:funcstr,0,len(l:funcstr)-1)
endfunction

let g:func = ""

function ClosingParanthesis()
    let l:func = GetCurrentFunction()
    if l:func != g:func
        wincmd z
    endif
endfunction

function PreviewPrototype()
    " don't do this if inside a preview window
    if &previewwindow
        return
    endif   
    let g:func = GetCurrentFunction()
    if g:func != ""
        silent! execute ":ptag ".g:func
    endif
endfunction

