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

" Use `[g` and `]g` to navigate diagnostics
" nmap <silent> [g <Plug>(coc-diagnostic-prev)
" nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
" xmap if <Plug>(coc-funcobj-i)
" xmap af <Plug>(coc-funcobj-a)
" omap if <Plug>(coc-funcobj-i)
" omap af <Plug>(coc-funcobj-a)

" Introduce class/struct/interface text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
" xmap ic <Plug>(coc-classobj-i)
" xmap ac <Plug>(coc-classobj-a)
" omap ic <Plug>(coc-classobj-i)
" omap ac <Plug>(coc-classobj-a)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>


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
" let g:lightline.buffer_logo = ' '
" let g:lightline.buffer_readonly_icon = ''
" let g:lightline.buffer_modified_icon = ''
" let g:lightline.buffer_git_icon = ' '
" let g:lightline.buffer_ellipsis_icon = '..'
" let g:lightline.buffer_expand_left_icon = '◀ '
" let g:lightline.buffer_expand_right_icon = ' ▶'
" let g:lightline.buffer_active_buffer_left_icon = ''
" let g:lightline.buffer_active_buffer_right_icon = ''
" let g:lightline.buffer_separator_icon = '  '
let g:lightline.branch_symbol = ' '
let g:lightline.separator = { 'left': '', 'right': ''}
let g:lightline.subseparator = { 'left': '|', 'right': '|' }

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


" Enable spellchecking in natural language files
augroup NaturalLanguage
    autocmd!
    autocmd BufRead,BufNewFile *.md,*.rst,*.txt setlocal spell spelllang=en_us
    autocmd FileType gitcommit setlocal spell spelllang=en_us
augroup END

" Only allow sourcing of unsafe commands if such files are owned by my user
set secure

" Prefer python3 when both can be used
set pyx=3
