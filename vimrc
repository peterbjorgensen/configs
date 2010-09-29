filetype plugin on
filetype indent on
syntax on
source /usr/share/vimfiles/plugin/comments.vim
colorscheme darkZ
if hostname() == "archpad" "smaller font for laptop
	set guifont=Monospace\ 8
else
	set mouse=a
	set ttymouse=xterm2 "for scrolling with urxvt
endif
set hlsearch
set guioptions-=m
set guioptions-=T
set guioptions+=c "show simple dialogs in commandline
set directory=/home/peter/.vim/swp,.,/tmp,/var/tmp
set runtimepath+=/usr/share/vim,/usr/share/vimfiles,/usr/share/vim/vim72/
set backupdir=~/.vim/backup "backup dir
set incsearch "start searching as you type
set showcmd "show the number of bytes marked in visual mode

"let g:mapleader = '½'
"let g:maplocalleader = '½'

"set spell
let spell_auto_type="tex,doc,mail"

"General mappings
nnoremap æ :bp!<CR>
nnoremap ø :bn!<CR>
nnoremap å :cclose<CR>
noremap <C-q> <Esc>:confirm bd<CR>
"alt-a decrease number under cursor
nnoremap ª :normal! <C-x><CR>
nnoremap á :normal! <C-x><CR>
"alt-g
noremap ŋ  
noremap ç 

"Completekey for ctags
imap ½ <C-r>=CompleteKey("\<C-x>\<C-o>")<CR>

"Cursor change color in console vim when entering/leaving insert mode
if &term =~ "urxvt""
	"Set the cursor white in cmd-mode and orange in insert mode
	let &t_EI = "\<Esc>]12;green\x9c"
	let &t_SI = "\<Esc>]12;orange\x9c"
	"We normally start in cmd-mode
	silent !echo -e "\e]12;green\x9c"
endif

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

"buftabs settings
let g:buftabs_only_basename=1
nnoremap <F5> :buffers<CR>:buffer<Space>

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
"
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

""""""""""""""""
""""" c, c++ 
""""""""""""""""
autocmd Filetype c,cpp call Autocmd_c()
function! Autocmd_c()
	setlocal omnifunc=LundComplete
	let b:lundCompleteTagsCmd = "ctags -f /tmp/tagslocal --c++-kinds=+pl ".
		\"--language-force=c++ --fields=+iaS --extra=+q /tmp/tagslocal_source"
	let b:lundCompleteOmnifunc = "omni#cpp#complete#Main"
	call UseTags("ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .")
	call UseFunctionPreview()
	call UseFunctionHighlighting()
endfunction
" Searching local variables do not require brackets to be in first column
let OmniCpp_LocalSearchDecl = 1
let OmniCpp_ShowAccess = 0		" Do not show access modifiers ('+', '#', '-')
let OmniCpp_ShowPrototypeInAbbr = 1	" Show prototype in popup menu


"""""""""""""""""""""""""
""""""""Python specific
""""""""""""""""""""""""
autocmd FileType python call Autocmd_Python()

let g:pydiction_location = '/usr/share/pydiction/complete-dict'

function! Autocmd_Python()
	setlocal expandtab
	source /usr/share/vim/vimfiles/plugin/ropevim.vim
	"ropevim settings
	let g:ropevim_codeassist_maxfixes=10
	let g:ropevim_guess_project=1
	let g:ropevim_vim_completion=1
	let g:ropevim_enable_autoimport=1
	let g:ropevim_extended_complete=1
	call UseTags
		\("/usr/lib/python2.6/Tools/scripts/ptags.py $(find . -name '*.py')")
	imap <buffer> ½ <C-R>=CompleteKey(
		\"<C-v><C-R>=RopeCodeAssistInsertMode()<C-v><CR><C-v><C-p>")<CR>
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
"""""""" JAVA specific
"""""""""""""""""""""""""
autocmd FileType java call Autocmd_Java()
function! Autocmd_Java()
	nnoremap <silent> <buffer> <cr> :JavaSearchContext<cr>
	nnoremap <silent> <buffer> <leader>d :JavaDocSearch -x declarations<cr>
	nnoremap <silent> <buffer> <leader>i :JavaImport<cr>
	setlocal omnifunc=javacomplete#Complete
	call UseTags("ctags -R --fields=+iaS --extra=+q .")
	call UseFunctionPreview()
	call UseFunctionHighlighting()
endfunction

" other languages
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP

" Used funcitons
function! UseFunctionHighlighting()
	syntax match Function excludenl /\h\w*\s*(/me=e-1
	highlight Function ctermfg=2 guifg=Cyan
endfunction

"""""""""""""""""""""""""
"""""""" LATEX options
"""""""""""""""""""""""""
set grepprg=egrep\ -nH\ $*
let g:tex_flavor='latex'
let g:Tex_FormatDependency = 'pdf'
let g:Tex_Leader = '<'
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_CompileRule_pdf = 'make figs && make figs && latexmk -silent -pdf $*'
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
function! Autocmd_Tex()
	set fileencoding=latin1
	setlocal spell spelllang=en
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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Autocompletion, tags, etc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CompleteKey(key)
	if pumvisible()
		return "\<C-n>"
	else
		return a:key
	endif
endfunction
" ctags
function! UseTags(tagsCmd)
	let b:tagsCmd = a:tagsCmd
	map <buffer> <silent> <F2> :call GenerateTags(1)<CR>
endfunction
function! GenerateTags(force)
	let l:tagsfound = 0
    let l:origdir = getcwd()
    while getcwd() != "/"
		if filereadable("tags")
			let l:tagsfound = 1
			let l:tagfile = fnameescape(getcwd() . "tags")
			set tags+=l:tagfile
			break
		endif
        cd ..
    endwhile
	if l:tagsfound != 1 && a:force
		let l:tagdir = input("Tagdir: ",l:origdir,"dir")
		if isdirectory(l:tagdir) 
			execute "cd " . fnameescape(l:tagdir)
			let l:tagsfound = 1
			let l:tagfile = fnameescape(getcwd() . "tags")
			set tags+=l:tagfile
		else
			echo "b:tagdir not a valid directory!"
		endif
	endif
    if l:tagsfound == 1
		call system(b:tagsCmd)
		if a:force == 1
			echo "Tags generated"
		endif
	endif
    execute "cd " . fnameescape(l:origdir)
endfunction

function! LundComplete(findstart, base)
	if a:findstart == 1
		execute "return ".b:lundCompleteOmnifunc."(a:findstart, a:base)"
	endif
	" find range of the current function
	let l:view = winsaveview()
	normal [{
	let l:firstline = line(".")
	normal %
	let l:lastline = line(".")
	call winrestview(l:view)
	" write to temporary file and generate tags
	execute l:firstline.",".l:lastline." write! /tmp/tagslocal_source"
	call system(b:lundCompleteTagsCmd)
	execute "let l:result = ".b:lundCompleteOmnifunc."(a:findstart, a:base)"
	call system("rm /tmp/tagslocal /tmp/tagslocal_source")
	return l:result
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Show function prototypes
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! UseFunctionPreview()
	imap <buffer> ) )<C-r>=ClosingParanthesis()<CR><BS>
	imap <buffer> <F6> <Esc>:call PreviewPrototype()<CR>a
	map <buffer> <F6> <Esc>:call PreviewPrototype()<CR>
	let b:previewFunction = ""
endfunction

" returns 0 if function was complete and 1 else
function! IsFuncComplete(str,pos)
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
function! GetCurrentFunction()
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

function! ClosingParanthesis()
    if GetCurrentFunction() != b:previewFunction
        wincmd z
    endif
endfunction

function! PreviewPrototype()
    " Don't do this if inside a preview window
    if &previewwindow
		wincmd z
        return
    endif
	" If a previewwindow already exists, just close it
	for winNr in range(1, winnr("$"))
		if getwinvar(winNr, "&previewwindow") == 1
			wincmd z
			return
		endif
	endfor
    let b:previewFunction = GetCurrentFunction()
    if b:previewFunction != ""
        silent! execute ":ptag ".b:previewFunction
	else
		wincmd }
    endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Make and build functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set makeprg=
function! MakeWithMaketarget()
	if exists("b:maketarget")
		call Make(b:maketarget)
	elseif exists("g:maketarget")
		call Make(g:maketarget)
	elseif exists("g:foldermaketarget")
		call Make(g:foldermaketarget)
	else
		echoe "b:maketarget, maketarget og foldermaketarget not defined"
	endif
endfunction
function! Make(...)
	redraw		" make sure any write's before Make() is shown
	if exists("a:1")
		let l:target = a:1
	else
		let l:target = ""
	endif
	if &l:makeprg != ""
		execute "make! " . l:target
		return
	endif
	let l:origdir = getcwd()
	while 1
		if filereadable("Makefile")
			let &l:makeprg="make"
			execute "make! " . l:target
			let &l:makeprg=""
			let l:winnr = winnr()
			botright cwindow
			execute l:winnr . "wincmd w"
			for error in getqflist()
				if error.valid == 1
					crewind
					break
				endif
			endfor
			break
		elseif filereadable("SConstruct")
			let &l:makeprg="scons"
			make!
			break
		elseif getcwd() == "/"
			echo "Makefile not found"
			break
		endif
		cd ..
	endwhile
    execute "cd " . fnameescape(l:origdir)
endfunction
