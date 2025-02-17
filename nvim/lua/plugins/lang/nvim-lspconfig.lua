return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "jose-elias-alvarez/typescript.nvim",
    init = function()
      LazyVim.lsp.on_attach(function(_, buffer)
          -- stylua: ignore
          vim.keymap.set( "n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
        vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
      end)
    end,
  },
  opts = {
    inlay_hints = {
      enabled = false,
    },
    servers = {
      omnisharp = {
        handlers = {
          ["textDocument/definition"] = function(...)
            return require("omnisharp_extended").handler(...)
          end,
        },
        keys = {
          {
            "gd",
            LazyVim.has("telescope.nvim") and function()
              require("omnisharp_extended").telescope_lsp_definitions()
            end or function()
              require("omnisharp_extended").lsp_definitions()
            end,
            desc = "Goto Definition",
          },
        },
        enable_roslyn_analyzers = true,
        organize_imports_on_format = true,
        enable_import_completion = true,
      },
      ts_ls = { enabled = false },
      eslint = {},
      tailwindcss = {
        filetypes = {},
      },
      volar = {
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
      },
      tsserver = {},
    },
    setup = {
      eslint = function()
        LazyVim.lsp.on_attach(function(client)
          if client.name == "eslint" then
            client.server_capabilities.documentFormattingProvider = true
          elseif client.name == "tsserver" then
            client.server_capabilities.documentFormattingProvider = false
          end
        end)
      end,
      -- tsserver = function(_, opts)
      --  require("typescript").setup({ server = opts })
      --  return true
      --end,

      volar = function()
        require("lspconfig").volar.setup({
          filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
        })
      end,
    },
  },
}
