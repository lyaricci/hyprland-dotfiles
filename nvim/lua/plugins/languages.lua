return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- FORMATERS
        "stylua",
        "shellcheck",
        "shfmt",
        "black",
        "markdownlint",
        "prettierd",
        -- LSPs
        "emmet-ls",
        "html-lsp",
        "css-lsp",
        "cssmodules-language-server",
        "eslint-lsp",
        "json-lsp",
        "lua-language-server",
        "tailwindcss-language-server",
        "typescript-language-server",
        "custom-elements-languageserver",
        -- DAPs
        "js-debug-adapter",
        -- LINTERS
        "commitlint",
        "markdownlint",
        "flake8",
      },
    },
  },

  -- REACTJS SNIPPETS
  "SirVer/ultisnips",
  "mlaursen/vim-react-snippets",

  -- TAILWINDCSS CONFIGS
  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      user_default_options = {
        tailwind = true,
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
    },
    opts = function(_, opts)
      -- original LazyVim kind icon formatter
      local format_kinds = opts.formatting.format
      opts.formatting.format = function(entry, item)
        format_kinds(entry, item) -- add icons
        return require("tailwindcss-colorizer-cmp").formatter(entry, item)
      end
    end,
  },
}
