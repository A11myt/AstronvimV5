-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
--              AstroNvim Configuration Table
-- All configuration changes should go inside of the table below

---@type LazySpec
local config = {
  --Options
  --plugins
  -- All other entries override the require("<key>").setup({...}) call for default plugins
  --
  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = false },

  highlight = {
    enable = true, -- false will disable the whole extension
    additional_vim_regex_highlighting = false,
  },

  -- Set the language to German
  -- vim.cmd('language de_DE.UTF-8'),
  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },
  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },

  {
    -- Alpha-Nvim (Startbildschirm)
    "goolord/alpha-nvim",
    opts = function(_, opts)
      local dashboard = require "alpha.themes.dashboard"

      dashboard.section.header.val = {
        "   █████    ██   ██  ███    ███ ██    ██ ████████",
        "  ██   ██ ████ ████  ████  ████  ██  ██     ██   ",
        "  ███████   ██   ██  ██ ████ ██   ████      ██   ",
        "  ██   ██   ██   ██  ██  ██  ██    ██       ██   ",
        "  ██   ██   ██   ██  ██      ██    ██       ██   ",
        "",
        "        ███    ██ ██    ██ ██ ███    ███",
        "        ████   ██ ██    ██ ██ ████  ████",
        "        ██ ██  ██ ██    ██ ██ ██ ████ ██",
        "        ██  ██ ██  ██  ██  ██ ██  ██  ██",
        "        ██   ████   ████   ██ ██      ██",
        "",
      }

      dashboard.section.buttons.val = {
        dashboard.button("n", "  New File", ":ene <BAR> startinsert <CR>"),
        dashboard.button("f", "  Find File", ":Telescope find_files<CR>"),
        dashboard.button("o", "󰈙  Recent Files", ":Telescope oldfiles<CR>"),
        dashboard.button("w", "󰈭 Find Word", ":Telescope live_grep<CR>"),
        dashboard.button("'", "  Bookmarks", ":Telescope marks<CR>"),
        dashboard.button("s", "  Last Session", ":SessionManager load_last_session<CR>"),
      }

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          dashboard.section.footer.val = {
            string.format(
              "⚡ Neovim loaded %d/%d plugins in %.2fms",
              stats.loaded or 0,
              stats.count or 0,
              stats.startuptime or 0
            ),
          }
          dashboard.section.header.opts = { position = "center", hl = "DiagnosticVirtualTextInfo" }
          -- dashboard.section.buttons.opts = { position = "center" }
          dashboard.section.footer.opts = { position = "center", hl = "Number" }
          pcall(vim.cmd.AlphaRedraw)
        end,
      })

      dashboard.layout = {
        { type = "padding", val = 2 },
        dashboard.section.header,
        { type = "padding", val = 1 },
        dashboard.section.buttons,
        { type = "padding", val = 1 },
        dashboard.section.footer,
      }
      opts.layout = {
        { type = "padding", val = 10 },
        dashboard.section.header,
        { type = "padding", val = 1 },
        dashboard.section.buttons,
        { type = "padding", val = 1 },
        dashboard.section.footer,
      }
    end,
  },
  require("null-ls").setup {
    sources = {
      require("null-ls").builtins.formatting.prettier.with {
        extra_args = { "--print-width", "9999", "--prose-wrap", "never" },
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup {
        defaults = {
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
          },
          prompt_prefix = "🔍 ",
          selection_caret = "➤ ",
          path_display = { "truncate" },
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,
            },
          },
        },
      }

      -- Optional: Keybindings for quick access
      vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { noremap = true, silent = true })
    end,
  },

  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function() require("telescope").load_extension "fzf" end,
  },
  {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup {
        surrounds = {
          ["<"] = {
            add = function()
              local tag = vim.fn.input "Tag: "
              return { "<" .. tag .. ">", "</" .. tag .. ">" }
            end,
          },
        },
      }
    end,
  },
  polish = function()
    local copilot_options = { silent = true, expr = true, script = true }
    vim.api.nvim_set_keymap("i", "<C-l>", "copilot#Accept(<Tab>)", copilot_options)
  end,
}
return config
