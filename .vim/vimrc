call plug#begin("~/.vim/plugged")

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-eslint', {'do': 'yarn install --frozen-lockfile'}
Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'vim-scripts/BufOnly.vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'tpope/vim-surround'
Plug 'nelstrom/vim-visual-star-search'
Plug 'tpope/vim-rhubarb'
Plug 'github/copilot.vim'
Plug 'vim-pandoc/vim-pandoc-syntax'

call plug#end()

" Configure VIM's settings
set hidden
set encoding=UTF-8
set number
set linebreak
set showbreak=+++
set textwidth=100
set showmatch
set visualbell

set hlsearch
set smartcase
set ignorecase
set incsearch

set autoindent
set expandtab
set shiftwidth=2
set smartindent
set smarttab
set softtabstop=2

set ruler
set cursorline

set undolevels=1000
set backspace=indent,eol,start
set laststatus=2
set noshowmode
set wildmenu
set wildmode=full
set history=200

set clipboard=unnamedplus

set signcolumn=yes

" Change the background color after 80 columns
let &colorcolumn=join(range(81,999),",")

" Change the command height to make for better error viewing
set cmdheight=2

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use `[g` and `]g` for navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
vmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use `:Format` for format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` for fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)


" Add diagnostic info for https://github.com/itchyny/lightline.vim
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status'
      \ },
      \ }

" Crew a new-line without going into insert mode
nmap <S-Cr> o<Esc>

" Easy expansion of the active file directory
cnoremap <expr> %% getcmdtype() == ':'?expand('%:h').'/' : '%%'

" Configure Vim for Ruby use as specified by
" https://github.com/vim-ruby/vim-ruby/wiki/VimRubySupport
set nocompatible
syntax on
filetype on
filetype indent on
filetype plugin on
runtime macros/matchit.vim
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1

" Configure vim-fugitive to have vertical splits
set diffopt+=vertical

" Change the hover tooltip/box to be white on black
highlight Pmenu ctermbg=black ctermfg=white

" Turn off autocomment
augroup auto_comment
  au!
  au FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
augroup END

" Enable papercolor-theme
" toggle light/dark: set background=light/dark
set t_Co=256
set background=dark
colorscheme PaperColor
let g:lightline = { 'colorscheme': 'PaperColor'  }
set noshowmode
nmap <script> <leader>cob  :<C-U>set background=<C-R>=&background == "dark" ? "light" : "dark"<CR><CR>

" Force coc.nvim to find the proper node binary
let g:coc_node_path = trim(system('which node'))
let g:coc_enable_debug = 1

" Configure enter key to select auto suggestion
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

" Duplicate tab
nnoremap <C-w>t :tab split<CR>

" Enable text wrapping at 80 characters for Markdown files
autocmd FileType markdown setlocal textwidth=80
