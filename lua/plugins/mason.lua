-- Customize Mason

---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = {
      -- Make sure to use the names found in `:Mason`
      ensure_installed = {
        -- install language servers
        "lua-language-server",
        -- install formatters
        "stylua",
        -- install debuggers
        -- "debugpy",
        -- install any other package
        "tree-sitter-cli",

        "arduino-language-server",
        "astro-language-server",
        "bash-language-server",
        "eslint-lsp",
        "firefox-debug-adapter",
        "html-lsp",
        "json-lsp",
        "gopls",
        -- "lua-language-server",
        "mdx-analyzer",
        "prettier",
        "selene",
        "stylua",
        "svelte-language-server",
        "tailwindcss-language-server",
        "typescript-language-server",
      },
    },
  },
}
