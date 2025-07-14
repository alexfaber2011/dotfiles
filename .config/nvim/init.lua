-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin setup
require("lazy").setup({
  -- Coc nvim for language support
  { "neoclide/coc.nvim", branch = "release" },

  -- UI enhancements
  "itchyny/lightline.vim",
  "airblade/vim-gitgutter",

  -- Fuzzy finder
  { "junegunn/fzf", build = function() vim.fn["fzf#install"]() end },
  "junegunn/fzf.vim",

  -- Editor enhancements
  "editorconfig/editorconfig-vim",
  "vim-scripts/BufOnly.vim",
  "NLKNguyen/papercolor-theme",
  "tpope/vim-surround",
  "nelstrom/vim-visual-star-search",

  -- Arduino
  "bergercookie/vim-debugstring",
  "tpope/vim-dispatch",

  -- Avante dependencies
  "nvim-treesitter/nvim-treesitter",
  "stevearc/dressing.nvim",
  "nvim-lua/plenary.nvim",
  "MunifTanjim/nui.nvim",
  {
    "echasnovski/mini.diff",
    config = function()
      local diff = require("mini.diff")
      diff.setup({
        -- Disabled by default
        source = diff.gen_source.none(),
      })
    end,
  },
  {
    "HakonHarnes/img-clip.nvim",
    opts = {
      filetypes = {
        codecompanion = {
          prompt_for_file_name = false,
          template = "[Image]($FILE_PATH)",
          use_absolute_path = true,
        },
      },
    },
  },

  -- Optional dependencies
  "hrsh7th/nvim-cmp",
  "nvim-tree/nvim-web-devicons",
  "HakonHarnes/img-clip.nvim",

  -- Avante
--{
--  "yetone/avante.nvim", 
--  branch = "main", 
--  build = "make",
--  config = function()
--    -- Configure Avante
--    require('avante').setup()
--  end
--},
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp", -- Optional
      "nvim-tree/nvim-web-devicons", -- Optional
      "HakonHarnes/img-clip.nvim", -- Optional
    },
    config = function()
      require("codecompanion").setup({
        strategies = {
          chat = {
            adapter = "anthropic",
          },
          inline = {
            adapter = "anthropic",
          },
        },
      })
    end,
  },
})

-- Configure Neovim's settings
vim.opt.hidden = true
vim.opt.encoding = 'UTF-8'
vim.opt.number = true
vim.opt.linebreak = true
vim.opt.showbreak = '+++'
vim.opt.textwidth = 100
vim.opt.showmatch = true
vim.opt.visualbell = true

vim.opt.hlsearch = true
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.incsearch = true

vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.softtabstop = 2

vim.opt.ruler = true
vim.opt.cursorline = true

vim.opt.undolevels = 1000
vim.opt.backspace = "indent,eol,start"
vim.opt.laststatus = 2
vim.opt.showmode = false
vim.opt.wildmenu = true
vim.opt.wildmode = "full"
vim.opt.history = 200

-- Use system clipboard
vim.opt.clipboard = "unnamedplus"

vim.opt.signcolumn = "yes"

-- Change the background color after 80 columns
vim.opt.colorcolumn = table.concat(vim.fn.range(81, 999), ",")

-- Change the command height for better error viewing
vim.opt.cmdheight = 2

-- Tab completion configuration
vim.cmd([[
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> for trigger completion
inoremap <silent><expr> <c-space> coc#refresh()
]])

-- Navigation keymaps
vim.cmd([[
" Use `[g` and `]g` for navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
]])

-- Documentation and symbol highlighting
vim.cmd([[
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
]])

-- Code refactoring keymaps
vim.cmd([[
" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
]])

-- File type specific settings
vim.api.nvim_create_augroup("mygroup", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "mygroup",
  pattern = {"typescript", "json"},
  command = "setl formatexpr=CocAction('formatSelected')"
})
vim.api.nvim_create_autocmd("User", {
  group = "mygroup",
  pattern = "CocJumpPlaceholder",
  callback = function() vim.fn.CocActionAsync('showSignatureHelp') end
})

-- Code actions
vim.cmd([[
" Remap for do codeAction of selected region
vmap <leader>c  <Plug>(coc-codeaction-selected)
nmap <leader>c  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>cc  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)
]])

-- Commands
vim.api.nvim_create_user_command('Format', function() vim.fn.CocAction('format') end, {})
vim.api.nvim_create_user_command('Fold', function(opts) vim.fn.CocAction('fold', opts.args) end, { nargs = '?' })

-- Lightline configuration
vim.g.lightline = {
  colorscheme = 'wombat',
  active = {
    left = {
      { 'mode', 'paste' },
      { 'cocstatus', 'readonly', 'filename', 'modified' }
    }
  },
  component_function = {
    cocstatus = 'coc#status'
  }
}

-- Additional keymaps
vim.cmd([[
" Create a new-line without going into insert mode
nmap <S-Cr> o<Esc>

" Easy expansion of the active file directory
cnoremap <expr> %% getcmdtype() == ':'?expand('%:h').'/' : '%%'
]])

-- Ruby configuration
vim.cmd([[
syntax on
filetype on
filetype indent on
filetype plugin on
runtime macros/matchit.vim
]])

vim.api.nvim_create_autocmd("FileType", {
  pattern = {"ruby", "eruby"},
  callback = function()
    vim.g.rubycomplete_buffer_loading = 1
    vim.g.rubycomplete_classes_in_global = 1
    vim.g.rubycomplete_rails = 1
  end
})

-- Git configuration  
vim.opt.diffopt:append("vertical")

-- Git commands via coc-git
vim.cmd([[
command! -range GBrowse CocCommand git.browserOpen
command! -nargs=* Git CocCommand git.<args>
command! -range Gblame CocCommand git.showBlameDoc

" Git hunk navigation
nmap [c <Plug>(coc-git-prevchunk)
nmap ]c <Plug>(coc-git-nextchunk)
]])

-- Pmenu highlight
vim.cmd("highlight Pmenu ctermbg=black ctermfg=white")

-- Turn off autocomment
vim.api.nvim_create_augroup("auto_comment", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "auto_comment",
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove("c")
    vim.opt_local.formatoptions:remove("r")
    vim.opt_local.formatoptions:remove("o")
  end
})

-- Theme configuration
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.cmd("colorscheme PaperColor")
vim.g.lightline = { colorscheme = 'PaperColor' }
vim.opt.showmode = false
vim.cmd([[nmap <script> <leader>cob :<C-U>set background=<C-R>=&background == "dark" ? "light" : "dark"<CR><CR>]])

-- COC configuration
vim.g.coc_global_extensions = {
  'coc-tsserver',
  'coc-json', 
  'coc-eslint',
  'coc-prettier',
  'coc-git'
}
vim.g.coc_node_path = vim.fn.trim(vim.fn.system('which node'))
vim.g.coc_enable_debug = 1
vim.cmd([[inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"]])

-- Tab management
vim.cmd([[nnoremap <C-w>t :tab split<CR>]])

-- Markdown configuration
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.textwidth = 80
  end
})

-- Ensure markdown treesitter parsers are installed
vim.cmd([[
  autocmd VimEnter * TSInstall! markdown markdown_inline
]])

-- FZF configuration
vim.cmd([[nnoremap <leader><leader> :Files<CR>]])

vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
