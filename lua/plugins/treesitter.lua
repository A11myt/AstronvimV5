
-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "json",
      "html",
      "markdown",
      "typescript",
      "tsx",
      "astro",
      "javascript",
      "go",
      "css", -- add more arguments for adding more treesitter parsers
      -- add more arguments for adding more treesitter parsers
    },
  },
}
