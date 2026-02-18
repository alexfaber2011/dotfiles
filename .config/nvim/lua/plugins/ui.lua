return {
  -- Auto dark/light mode based on system theme
  {
    "f-person/auto-dark-mode.nvim",
    opts = {
      update_interval = 1000,
      set_dark_mode = function()
        vim.o.background = "dark"
      end,
      set_light_mode = function()
        vim.o.background = "light"
      end,
    },
  },

  -- PaperColor colorscheme
  {
    "NLKNguyen/papercolor-theme",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("PaperColor")
    end,
  },

  -- Lightline status bar
  {
    "itchyny/lightline.vim",
    lazy = false,
    config = function()
      vim.g.lightline = {
        colorscheme = "PaperColor",
        active = {
          left = {
            { "mode", "paste" },
            { "readonly", "filename", "modified" },
          },
          right = {
            { "lineinfo" },
            { "percent" },
            { "fileformat", "fileencoding", "filetype" },
          },
        },
        component_function = {
          filename = "LightlineFilename",
        },
      }

      -- Show relative path in lightline
      vim.cmd([[
        function! LightlineFilename()
          let root = fnamemodify(get(b:, 'git_dir'), ':h')
          let path = expand('%:p')
          if path[:len(root)-1] ==# root
            return path[len(root)+1:]
          endif
          return expand('%:t')
        endfunction
      ]])
    end,
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup({
        indent = {
          char = "│",
        },
        scope = {
          enabled = true,
          show_start = false,
          show_end = false,
        },
      })
    end,
  },

  -- Better UI for vim.ui.select and vim.ui.input
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = function()
      require("dressing").setup({
        input = {
          enabled = true,
          border = "rounded",
        },
        select = {
          enabled = true,
          backend = { "fzf_lua", "fzf", "builtin" },
        },
      })
    end,
  },
}
