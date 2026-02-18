return {
  -- Mason: auto-install LSP servers
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },

  -- Bridge mason + lspconfig (for auto-installing servers)
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "ts_ls",
          "eslint",
          "solargraph",
        },
        automatic_installation = true,
      })
    end,
  },

  -- LSP configuration using native Neovim 0.11 API
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      -- Enhanced capabilities for nvim-cmp
      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- Diagnostic configuration (Neovim 0.11+ style)
      vim.diagnostic.config({
        virtual_text = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = true,
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
      })

      -- Global LSP keymaps (work even if LSP not attached, with helpful error)
      local function lsp_keymap(key, fn, desc)
        vim.keymap.set("n", key, function()
          if #vim.lsp.get_clients({ bufnr = 0 }) == 0 then
            vim.notify("No LSP attached. Run :LspInfo to check.", vim.log.levels.WARN)
          else
            fn()
          end
        end, { noremap = true, silent = true, desc = desc })
      end

      lsp_keymap("gd", vim.lsp.buf.definition, "Go to definition")
      lsp_keymap("gr", vim.lsp.buf.references, "Go to references")
      lsp_keymap("gi", vim.lsp.buf.implementation, "Go to implementation")
      lsp_keymap("gy", vim.lsp.buf.type_definition, "Go to type definition")
      lsp_keymap("K", vim.lsp.buf.hover, "Hover documentation")
      lsp_keymap("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
      lsp_keymap("<leader>c", vim.lsp.buf.code_action, "Code action")

      -- Diagnostic keymaps (work without LSP)
      vim.keymap.set("n", "[g", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
      vim.keymap.set("n", "]g", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
      vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })

      -- Quick fix: Apply code action fixes for current line
      vim.keymap.set("n", "<leader>qf", function()
        vim.lsp.buf.code_action({
          filter = function(action)
            return action.kind and (action.kind:match("^quickfix") or action.kind:match("^source%.fixAll"))
          end,
          apply = true,
        })
      end, { desc = "Quick fix current line" })

      -- Configure LSP servers using vim.lsp.config (Neovim 0.11+)

      -- TypeScript/JavaScript
      vim.lsp.config("ts_ls", {
        capabilities = capabilities,
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
      })

      -- ESLint (supports both node_modules and Yarn PnP)
      vim.lsp.config("eslint", {
        capabilities = capabilities,
        settings = {
          workingDirectories = { mode = "auto" },
          -- nodePath is set dynamically below based on project type
        },
        on_init = function(client)
          -- Auto-detect Yarn PnP and set nodePath accordingly
          local root = client.config.root_dir
          if root then
            local pnp_cjs = root .. "/.pnp.cjs"
            local pnp_js = root .. "/.pnp.js"
            if vim.uv.fs_stat(pnp_cjs) or vim.uv.fs_stat(pnp_js) then
              client.config.settings.nodePath = ".yarn/sdks"
            end
          end
          return true
        end,
      })

      -- ESLint auto-fix on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
        callback = function()
          vim.cmd("silent! EslintFixAll")
        end,
      })

      -- Solargraph (Ruby LSP with YARD-based type inference)
      vim.lsp.config("solargraph", {
        capabilities = capabilities,
        settings = {
          solargraph = {
            diagnostics = true,
            completion = true,
            hover = true,
            references = true,
            rename = true,
            symbols = true,
          },
        },
      })

      -- Enable all configured servers
      vim.lsp.enable({ "ts_ls", "eslint", "solargraph" })
    end,
  },

  -- Completion engine
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })
    end,
  },

  -- Formatting with conform.nvim
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          javascript = { "prettier" },
          javascriptreact = { "prettier" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          json = { "prettier" },
          html = { "prettier" },
          css = { "prettier" },
          markdown = { "prettier" },
          yaml = { "prettier" },
          ruby = { "rubocop" },
        },
        format_on_save = {
          timeout_ms = 3000,
          lsp_fallback = true,
        },
      })
    end,
  },
}
