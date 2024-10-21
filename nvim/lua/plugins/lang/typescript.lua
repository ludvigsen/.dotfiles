return {
  -- add tsserver and setup with typescript.nvim instead of lspconfig
  --  {
  --    "neovim/nvim-lspconfig",
  --    ---@class PluginLspOpts
  --    opts = {
  --      ---@type lspconfig.options
  --      -- you can do any additional lsp server setup here
  --      -- return true if you don't want this server to be setup with lspconfig
  --      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
  --      setup = {
  --        -- example to setup with typescript.nvim
  --        tsserver = function(_, opts)
  --          require("typescript").setup({ server = opts })
  --          return true
  --        end,
  --        -- Specify * to use this function as a fallback for any server
  --        -- ["*"] = function(server, opts) end,
  --      },
  --    },
  --  },
  -- {
  --   "neovim/nvim-lspconfig",
  --   dependencies = {
  --     "jose-elias-alvarez/typescript.nvim",
  --     init = function()
  --       LazyVim.lsp.on_attach(function(_, buffer)
  --         -- stylua: ignore
  --         vim.keymap.set( "n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
  --         vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
  --       end)
  --     end,
  --   },
  --   opts = {
  --     servers = {
  --       ts_ls = { enabled = false },
  --       eslint = {},
  --       tailwindcss = {
  --         filetypes = {},
  --       },
  --       volar = {
  --         filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
  --       },
  --       tsserver = {},
  --     },
  --     setup = {
  --       eslint = function()
  --         LazyVim.lsp.on_attach(function(client)
  --           if client.name == "eslint" then
  --             client.server_capabilities.documentFormattingProvider = true
  --           elseif client.name == "tsserver" then
  --             client.server_capabilities.documentFormattingProvider = false
  --           end
  --         end)
  --       end,
  --       -- tsserver = function(_, opts)
  --       --  require("typescript").setup({ server = opts })
  --       --  return true
  --       --end,

  --       volar = function()
  --         require("lspconfig").volar.setup({
  --           filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
  --         })
  --       end,
  --     },
  --   },
  -- },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "tsx",
        "typescript",
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        prettier = {
          prepend_args = { "--single-quote" },
        },
      },
    },
  },
}
