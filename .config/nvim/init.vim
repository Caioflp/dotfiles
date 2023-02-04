" Enable true color
set termguicolors

" Edit alternate file 
nnoremap <silent> <c-6> :e#<CR>

" syntax
syntax on

"File type plugin
filetype plugin on

" Textwidth
set textwidth=73

" ALWAYS use utf8 encoding
set encoding=utf-8

" to detect language
filetype on

" To put number the rows
set number

" Use relative numbering
set relativenumber

" Folding with space bar
nnoremap <space> za

" Proper indentation
set tabstop=4 softtabstop=0 expandtab shiftwidth=4

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  if has('persistent_undo')
    set undofile	" keep an undo file (undo changes after closing)
  endif
endif

"----------------------------Backup files directory----------------------------

set backupdir=~/.backup/,/tmp
set directory=~/.swp/,/tmp
set undodir=~/.undo/,/tmp

"--------------------------------Managing tabs---------------------------------

" work in progress

"-------------------------------Managing buffers--------------------------------

nnoremap <C-W> <C-W><C-W>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-W>

"-----------------------------------Vim-Plug------------------------------------

call plug#begin()
Plug 'tpope/vim-surround'
Plug 'lervag/vimtex'
Plug 'vim-scripts/indentpython.vim'
Plug 'SirVer/ultisnips'
Plug 'dense-analysis/ale'
Plug 'vim-python/python-syntax'
Plug 'JuliaEditorSupport/julia-vim'
Plug 'vim-airline/vim-airline'
Plug 'rebelot/kanagawa.nvim'
call plug#end()

"---------------------------------Colorschemes----------------------------------

set background=dark
colorscheme kanagawa

"-----------------------------------UltiSnips-----------------------------------

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetDirectories=["ultisnips"]

nnoremap ,as :UltiSnipsEdit<CR>

"------------------------------------vim-tex------------------------------------

" Stupid font warnings that pop-up in quickfix buffer
let g:vimtex_quickfix_ignore_filters = [
    \ '`U/rsfs/m/n',
    \ 'DeclareDelimAlias',
    \ 'Token not allowed in a PDF string',
    \ ]
let g:vimtex_version_check = 0
let g:vimtex_view_general_viewer = 'zathura'
" let g:vimtex_view_general_options_latexmk = '-reuse-instance'
"" set conceallevel=1
"" let g:tex_conceal='abdmg'

"------------------------------------Python------------------------------------

" syntax hightlighting
let python_highlight_all=1

" shortcut to test functions
function! g:PythonEvaluateBuffer()
  if !exists('b:python_buf')
    let b:python_buf = inputlist(["Select one of the following buffers:"] + map(tabpagebuflist(), { i, v -> i+1 .. ". " .. bufname(v) }))
  endif
  call term_sendkeys(b:python_buf, "from ". expand("%") ."\<BS>\<BS>\<BS> import *\<CR>" )
endfunction
 
nnoremap <Leader>p :call g:PythonEvaluateBuffer()<CR>

" python-syntax plugin
let g:python_highlight_builtins = 1
let g:python_highlight_builtin_objs	= 1
let g:python_highlight_builtin_types = 1
let g:python_highlight_builtin_funcs = 1
let g:python_highlight_builtin_funcs_kwarg = 1
let g:python_highlight_exceptions = 1
let g:python_highlight_string_formatting = 1
let g:python_highlight_string_format = 1
let g:python_highlight_string_templates = 1
let g:python_highlight_indent_errors = 1
let g:python_highlight_space_errors = 1
let g:python_highlight_doctests	= 1
let g:python_highlight_func_calls = 1
let g:python_highlight_class_vars = 1
let g:python_highlight_operators = 1
"-------------------------------Smooth Scrolling-------------------------------
function SmoothScroll(up)
    if a:up
        let scrollaction="\<c-y>"
    else
        let scrollaction="\<c-e>"
    endif
    exec "normal " . scrollaction
    redraw
    let counter=1
    while counter<&scroll
        let counter+=1
        sleep 7m
        redraw
        exec "normal " . scrollaction
    endwhile
endfunction

" nnoremap <silent> <C-U> :call SmoothScroll(1)<CR>
" nnoremap <silent> <C-D> :call SmoothScroll(0)<CR>

set mouse=a
set clipboard=unnamedplus
"let g:clipboard = {
"      \   'name': 'myClipboard',
"      \   'copy': {
"      \      '+': ['xsel', '-i'],
"      \      '*': ['xsel', '-i'],
"      \    },
"      \   'paste': {
"      \      '+': ['xsel', '-o'],
"      \      '*': ['xsel', '-o'],
"      \   },
"      \   'cache_enabled': 1,
"      \ }

" matchit
packadd! matchit

" Julia

hi link juliaParDelim Delimiter
hi link juliaSemicolon Operator
hi link juliaFunctionCall Identifier

" Python support
let g:python3_host_prog='/usr/bin/python'

" Airline stuff
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
