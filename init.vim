syntax on
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
if (has("termguicolors"))
	set termguicolors
	let $NVIM_TUI_ENABLE_TRUE_COLOR=1 "Some colorschemes expects this to be set
endif

filetype plugin on
filetype indent on

"set rtp^=/usr/share/vim/vimfiles/
set title
execute pathogen#infect()
"
" Theme and colors
let g:gruvbox_contrast_dark = 'hard'
let g:neodark#background = '#202020'
set background=dark
colorscheme darkZ
let g:airline_theme = 'papercolor'
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
let g:airline_symbols.linenr = ''


"Dont make statements bold
hi Statement gui=none


call plug#begin(stdpath('data') . '/plugged')
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'kabouzeid/nvim-lspinstall'

Plug 'ray-x/lsp_signature.nvim'

call plug#end()

set completeopt=menu,menuone,noselect

lua << EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
      end,
    },
    mapping = {
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      --['<C-y>'] = cmp.config.disable, -- If you want to remove the default `<C-y>` mapping, You can specify `cmp.config.disable` value.
      --['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      -- { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

  -- require "lsp_signature".setup()


  local nvim_lsp = require('lspconfig')

    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local on_attach = function(client, bufnr)
      local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
      local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

      -- Enable completion triggered by <c-x><c-o>
      buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

      -- Mappings.
      local opts = { noremap=true, silent=true }

      -- See `:help vim.lsp.*` for documentation on any of the below functions
      buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
      buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
      buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
      buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
      buf_set_keymap('n', '<space>k', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
      buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
      buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
      buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
      buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
      buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
      buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
      buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
      buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
      buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
      buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
      buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
      buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

    end

    -- Use a loop to conveniently call 'setup' on multiple servers and
    -- map buffer local keybindings when the language server attaches
    local servers = { 'pyright', 'clangd' }
    for _, lsp in ipairs(servers) do
      nvim_lsp[lsp].setup {
        capabilities = capabilities,
        on_attach = on_attach,
        flags = {
          debounce_text_changes = 150,
        }
      }
    end

    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = false,
            underline = true,
            signs = true,
        }
    )
EOF
autocmd CursorHold * lua vim.diagnostic.open_float({ focusable = false })
"autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()
set updatetime=300


set cursorline "Highlight current line
set mouse=a "Enable mouse for all modes

"General mappings
nnoremap <F8> :buffers<CR>:buffer<Space>
nnoremap <C-t> :lclose<CR>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>
"Change working directory to directory of current buffer
nnoremap ,cd :execute "cd" expand("%:h")<CR>:pwd<CR>

"Clear highlight when pressing escape in normal mode
nnoremap <esc> :nohl<cr>

set tabstop=4
set shiftwidth=4
set scrolloff=4

set wildmenu
set wildmode=list:longest,full
"set smartindent
set ignorecase "Search ignore case
set smartcase "Override ignorecase if search contains upper case
"set showbreak=¬
set showbreak=↪\ 
set listchars=tab:\|\ ,nbsp:␣,trail:·,extends:⟩,precedes:⟨

"set completeopt-=preview

set switchbuf=useopen
set list "Highlight whitespace characters
highlight Whitespace guibg=black guifg=cyan

set autoread
au FocusGained * :checktime "Check for changes

"more info for statusline
set laststatus=2
if has("statusline")
	set statusline=%<%f\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ %h%m%r%=%{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"]\ \"}%k\ %-14.(%l,%c%V%)\ %P
endif

"""""
"" SYNTASTIC setup
""""
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

nnoremap <F5> :SyntasticCheck<CR>
nnoremap <F6> :SyntasticReset<CR>
nnoremap <F7> :SyntasticToggleMode<CR>
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
"let g:syntastic_aggregate_errors = 1
"let g:syntastic_id_checkers = 0
"let g:syntastic_sort_aggregated_errors = 0
" Start in passive mode
let g:syntastic_mode_map = {
	\ "mode": "passive",
	\ "active_filetypes": [],
	\ "passive_filetypes": [] }
let g:syntastic_python_checkers = ["python", "pylint"]

"""""""""""""""""""""""""
"""""""" Python options
"""""""""""""""""""""""""
nnoremap <F9> :Docstring<CR>
nnoremap <F10> :DocstringTypes<CR>
let g:python_style = 'numpy'

"Indent after an open paren: >
let g:pyindent_open_paren = '&sw' "default is '&sw * 2'
"Indent after a nested paren: >
let g:pyindent_nested_paren = '&sw'
"Indent for a continuation line: >
let g:pyindent_continue = '&sw' "default is '&sw * 2'

"""""""""""""""""""""""""
"""""""" LATEX options
"""""""""""""""""""""""""
" I use <C-j> for naviating windows
" so prevent vim-latex-suite from overwriting
" This will effectively disable the <C-j> vim-latex jump in normal mode
nnoremap <SID>I_won’t_ever_type_this <Plug>IMAP_JumpForward

set grepprg=egrep\ -nH\ $*
let g:tex_flavor='latex'
let g:Tex_FormatDependency = 'pdf'
let g:Tex_Leader = '`'
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_CompileRule_pdf = 'make figs; make figs; latexmk -pdf -latexoption=--synctex=1 "$*"'
"let g:Tex_CompileRule_pdf = 'pdflatex --synctex=1 -interaction=nonstopmode $*'
let g:Tex_MultipleCompileFormats = 'pdf'
"let g:Tex_ViewRule_pdf = 'evince'
let g:Tex_GotoError = 0
let g:Tex_UseMakefile = 0
let g:Tex_AdvancedMath = 1 "Enables use of Alt-key shortcuts

autocmd BufRead,BufNewFile	*.tex	setlocal filetype=tex
autocmd BufEnter main.tex setlocal filetype=tex
autocmd BufReadPost main.aux setlocal nobuflisted
autocmd BufReadPost main.log setlocal nobuflisted

autocmd FileType tex call Autocmd_Tex()
function! Autocmd_Tex()
	set omnifunc=syntaxcomplete#Complete
	syntax spell toplevel
	"set fileencoding=latin1
	setlocal spell spelllang=en
	"setlocal textwidth=80
	inoremap <buffer> ½2	<Esc>:call TexClosePrev(0)<CR>a
	nmap <F3> :call Tex_CompileLatex()<CR>
	nmap <F4> :call SVED_Sync()<CR>
	call IMAP('HSI', '\SI{<++>}{<++>}<++>', 'tex')
	call IMAP('HSS', '_|<++>|<++>','tex')
	call IMAP('||', '|<++>|<++>','tex')
endfunction

"environment macros
let g:Tex_PromptedEnvironments = "align,align*,figure,equation,minipage,table,tabular,enumerate,itemize"
let g:Tex_Env_figure = "\
\\begin{figure}[htbp]\<CR>\
	\\centering\\includegraphics[width=<++>\\textwidth]{<++>}\<CR>\
	\\caption{<++>}\<CR>\
	\\label{fig:<++>}\<CR>\
\\end{figure}\<CR><++>"
let g:Tex_Env_minipage = "\
\\begin{figure}[htbp]\<CR>\
	\\centering\<CR>\
	\\begin{minipage}[c]{0.47\\textwidth}\<CR>\
		\\centering\<CR>\
		\\includegraphics[width=1\\textwidth]{<++>}\<CR>\
		\\caption{<++>}\<CR>\
		\\label{fig:<++>}\<CR>\
	\\end{minipage}\\hfill\<CR>\
	\\begin{minipage}[c]{0.47\\textwidth}\<CR>\
		\\centering\<CR>\
		\\includegraphics[width=1\\textwidth]{<++>}\<CR>\
		\\caption{<++>}\<CR>\
		\\label{fig:<++>}\<CR>\
	\\end{minipage}\<CR>\
\\end{figure}\<CR><++>"

