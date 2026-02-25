return {
  -- fzf for fuzzy finding
  {
    "junegunn/fzf",
    build = ":call fzf#install()",
  },
  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
    config = function()
      -- fzf keymaps
      vim.keymap.set("n", "<leader>\\", ":Files<CR>", { silent = true })
      vim.keymap.set("n", "<leader>b", ":Buffers<CR>", { silent = true })
      vim.keymap.set("n", "<leader>g", ":Rg<CR>", { silent = true })
      vim.keymap.set("n", "<leader>/", ":BLines<CR>", { silent = true })
    end,
  },

  -- Surround text objects
  {
    "tpope/vim-surround",
  },

  -- EditorConfig support
  {
    "editorconfig/editorconfig-vim",
  },

  -- Treesitter for better syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "bash",
        "css",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "ruby",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
    },
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },

  -- Comment toggling
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- Git integration (fugitive + rhubarb for :GBrowse and :Git blame)
  {
    "tpope/vim-fugitive",
    config = function()
      vim.api.nvim_create_user_command("GBlame", "Git blame", {})
    end,
  },
  {
    "tpope/vim-rhubarb", -- GitHub support for :GBrowse
    dependencies = { "tpope/vim-fugitive" },
  },

  -- Git signs in gutter (replaces gitgutter)
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              return "]c"
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, { expr = true })

          map("n", "[c", function()
            if vim.wo.diff then
              return "[c"
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, { expr = true })

          -- Actions
          map("n", "<leader>hs", gs.stage_hunk)
          map("n", "<leader>hr", gs.reset_hunk)
          map("n", "<leader>hp", gs.preview_hunk)
          map("n", "<leader>hb", function()
            gs.blame_line({ full = true })
          end)
        end,
      })
    end,
  },
}
