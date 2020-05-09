inoremap jk <ESC>
let mapleader = " "

filetype plugin indent on

set relativenumber 
set encoding=utf-8
set clipboard=unnamedplus

au BufNewFile,BufRead *.py
    \ set expandtab       |" replace tabs with spaces
    \ set autoindent      |" copy indent when starting a new line
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4

" Plug package installation
"
call plug#begin('~/.config/nvim/plugged')

Plug 'itchyny/lightline.vim'                                            " Lightweight statusline without slow plugin integrations
Plug 'majutsushi/tagbar'                                                " Open tag navigation split with :Tagbar
Plug 'ryanoasis/vim-devicons'                                           " For file icons in lots of plugins
Plug 'sheerun/vim-polyglot'                                             " Add syntax highlighting for a large range of filetypes

" Python
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}			" Python semantic highlighting
Plug 'neoclide/coc.nvim', {'branch': 'release'}				" Code completion for python

" Git
Plug 'jreybert/vimagit'							" Vim equivalent of emacs magit
Plug 'tpope/vim-rhubarb'						" Package for git browsing capabilities

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }       " Fuzzy file++ searching
Plug 'junegunn/fzf.vim'                                                 " Asynchronous file/tags searcher


call plug#end()


" ##############################################
" NERDtree
" ##############################################

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0]

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") && v:this_session == "" | NERDTree | endif

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

" #############################################
" Git Gutter
" #############################################


let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '>'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '^'
let g:gitgutter_sign_modified_removed = '<'

let g:gitgutter_override_sign_column_highlight = 1

set updatetime=250

nmap <Leader>gn <Plug>(GitGutterNextHunk) " git next
nmap <Leader>gp <Plug>(GitGutterPrevHunk)  " git previous

" Hunk-add and hunk-revert for chunk staging
nmap <Leader>ga <Plug>(GitGutterStageHunk)  " git add (chunk)
nmap <Leader>gu <Plug>(GitGutterUndoHunk)   " git undo (chunk)

" ##############################################
" Vim Magit
" ##############################################


" Open vimagit pane
nnoremap <leader>gs :Magit<CR>

" Push to remote
nnoremap <leader>gP :! git push<CR>  " git Push

" ##############################################
" Vim fugitive and vim rhubarb
" #############################################

" Show commits for every source line
nnoremap <Leader>gb :Gblame<CR>  " git blame

" Open current line in the browser
nnoremap <Leader>gbb :.Gbrowse<CR>

" Open visual selection in the browser
vnoremap <Leader>gb :Gbrowse<CR>

" Add the entire file to the staging area
nnoremap <Leader>gaf :Gw<CR>      " git add file


" ##############################################
" fzf
" ##############################################
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1


" ################################################
" CoC Python Code Completion
" ################################################

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif


" Visual

" ################################################
" Statusline
" ################################################

" Lightline settings should be placed before setting the colorscheme
" Settings for vim-devicons for lightline
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left':  [ [ 'mode', 'paste' ],
      \              [ 'readonly', 'relativepath', 'gitbranch'],
      \            ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
	      \              [ 'fileformat', 'fileencoding', 'filetype'] ]
      \   },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \   'bufferinfo': 'lightline#buffer#bufferinfo',
      \ },
      \ 'tab': {
      \   'active': [ 'filename', 'modified' ],
      \   'inactive': [ 'filename', 'modified' ],
      \ },
      \ 'tabline': {
      \   'left': [ [ 'tabs' ] ],
      \   'right': [],
      \ },
      \ 'component_expand': {
      \   'buffercurrent': 'lightline#buffer#buffercurrent',
      \   'bufferbefore': 'lightline#buffer#bufferbefore',
      \   'bufferafter': 'lightline#buffer#bufferafter',
      \ },
      \ 'component_type': {
      \   'buffercurrent': 'tabsel',
      \   'bufferbefore': 'raw',
      \   'bufferafter': 'raw',
      \ },
      \ 'component': {
      \   'separator': '',
      \   'tagbar': '%{tagbar#currenttag("%s", "", "f")}',
      \ },
      \ }

"""" lightline-buffer
set showtabline=2  " always show tabline

" lightline-buffer ui settings
" replace these symbols with ascii characters if your environment does not support unicode
"let g:lightline_buffer_logo = ' '
let g:lightline_buffer_readonly_icon = ''
let g:lightline_buffer_modified_icon = ''
let g:lightline_buffer_git_icon = ' '
let g:lightline_buffer_ellipsis_icon = '..'
let g:lightline_buffer_expand_left_icon = '◀ '
let g:lightline_buffer_expand_right_icon = ' ▶'
let g:lightline_buffer_active_buffer_left_icon = ''
let g:lightline_buffer_active_buffer_right_icon = ''
let g:lightline_buffer_separator_icon = '  '

" lightline-buffer function settings
let g:lightline_buffer_show_bufnr = 0
let g:lightline_buffer_rotate = 0
let g:lightline_buffer_fname_mod = ':t'
let g:lightline_buffer_excludes = ['vimfiler']

let g:lightline_buffer_maxflen = 30
let g:lightline_buffer_maxfextlen = 3
let g:lightline_buffer_minflen = 16
let g:lightline_buffer_minfextlen = 3
let g:lightline_buffer_reservelen = 20


let g:semshi#excluded_hl_groups = ['local']
let g:semshi#mark_selected_nodes = 1
let g:semshi#error_sign = v:true
let g:semshi#error_sign_delay = 1.5
let g:semshi#always_update_all_highlights = v:false
let g:semshi#tolerate_syntax_errors = v:true
let g:semshi#update_delay_factor = 0.0
let g:semshi#self_to_attribute = v:true	

colorscheme gruvbox
set background=dark

" Use 256 colors in gui_running mode
if !has('gui_running')
  set t_Co=256
endif

" Make sure that 256 colors are used
set termguicolors

set laststatus=2

