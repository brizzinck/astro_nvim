---@type table
return {
  {
    "tpope/vim-dadbod",
    cmd = { "DB", "DBUI", "DBUIToggle", "DBUIAddConnection" }
  },

  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = { "tpope/vim-dadbod" },
    cmd = { "DBUI", "DBUIToggle" },
    config = function()
      vim.g.db_ui_save_location = "~/.config/nvim/db_connections"
    end,
  },

  {
    "kristijanhusak/vim-dadbod-completion", 
    config = function()
      vim.cmd([[autocmd FileType sql lua require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })]])
    end,
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<C-Space>",
            next = "<C-n>",
            prev = "<C-p>",
            dismiss = "<C-e>",
          },
        },
        panel = { 
          enabled = true,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<C-o>",
          },
        },
      })
    end,
  },
  
  {
    "rebelot/kanagawa.nvim", 
    config = function()
      require("kanagawa").setup({
        compile = true,
        undercurl = true,
        commentStyle = { italic = true },
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        transparent = false,
        dimInactive = false,
        terminalColors = true,
        theme = "wave",
        background = {
          dark = "wave",
          light = "lotus",
        },
      })
      vim.cmd("colorscheme kanagawa") 
    end,
  },
  
  {
    "scottmckendry/cyberdream.nvim", 
    config = function()
      require("cyberdream").setup({
        transparent = false,        
        italic_comments = false,   
        hide_fillchars = false,   
        borderless_telescope = true, 
        terminal_colors = true,     
        cache = false,               

        theme = {
          variant = "default",       
          saturation = 1,           
          highlights = {
            Comment = { fg = "#696969", bg = "NONE", italic = true },
          },
          overrides = function(colors)
            return {
              Comment = { fg = colors.green, bg = "NONE", italic = true },
              ["@property"] = { fg = colors.magenta, bold = true },
            }
          end,
          colors = {
            bg = "#000000",
            green = "#ffffff",
            magenta = "#5ea1ff",
          },
        },

        extensions = {
          telescope = true, 
          notify = true,   
          mini = true,      
        },
      })
      vim.cmd("colorscheme cyberdream")
    end,
  },
  {
    "eddyekofo94/gruvbox-flat.nvim",
    config = function()
      vim.o.background = "dark"
      vim.g.gruvbox_flat_style = "hard"
      vim.cmd("colorscheme gruvbox-flat")
    end,
  },
  
  {
    "sainnhe/sonokai",
    config = function()
      vim.o.background = "dark"
      vim.g.sonokai_style = "andromeda"
      vim.cmd("colorscheme sonokai")
    end,
  },
  
  {
    "shaunsingh/nord.nvim",
    config = function()
      vim.o.background = "dark"
      vim.cmd("colorscheme nord")
    end,
  },

  {
    "folke/tokyonight.nvim",
    config = function()
      vim.o.background = "dark"
      vim.g.tokyonight_style = "storm"
      vim.cmd("colorscheme tokyonight")
    end,
  },
  
  {
    "catppuccin/nvim",
    config = function()
      vim.o.background = "dark"
      vim.g.catppuccin_flavour = "macchiato"
      vim.cmd("colorscheme catppuccin")
    end,
  },


  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          source = "always",
          border = "rounded",
          position = { row = 1, col = vim.o.columns - 50 },
        },
      })

      vim.keymap.set("n", "<leader>d", function()
        vim.diagnostic.open_float(nil, { focus = false })
      end, { desc = "Open diagnostics float" })

    end,
  },

  {
    "simrat39/rust-tools.nvim",
    ft = { "rust", "toml" },
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      local rt = require("rust-tools")
      local ra = require("lspconfig")

      rt.setup({
        tools = {
          inlay_hints = {
            auto = true,
            only_current_line = false,
            show_parameter_hints = true,
            parameter_hints_prefix = "<- ",
            other_hints_prefix = "=> ",
          },
        },
        server = {
          on_attach = function(client, bufnr)
            local opts = { buffer = bufnr }

            vim.keymap.set("n", "<leader>ra", vim.lsp.buf.code_action, opts) 
            vim.keymap.set("n", "<leader>rr", vim.lsp.buf.rename, opts) 

            vim.keymap.set("n", "<leader>rf", function()
              vim.lsp.buf.format({ async = true })
            end, opts) 
            vim.keymap.set("n", "<leader>rh", vim.lsp.buf.hover, opts) 
            vim.keymap.set("n", "<leader>rs", vim.lsp.buf.signature_help, opts) 
            vim.keymap.set("n", "<leader>rd", vim.lsp.buf.definition, opts) 
            vim.keymap.set("n", "<leader>ri", vim.lsp.buf.implementation, opts) 
            vim.keymap.set("n", "<leader>rR", vim.lsp.buf.references, opts) 
            vim.keymap.set("n", "<leader>rc", vim.lsp.codelens.run, opts)

            vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts) 
            vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts) 
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts) 
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) 

            if client.server_capabilities.documentFormattingProvider then
              vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                  vim.lsp.buf.format({ async = false })
                end,
              })
            end
          end,
        },
      })
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp", "onsails/lspkind-nvim" },
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      cmp.setup({
        mapping = {
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
          }),
        },
      })
    end,
  },

  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require("astronvim.plugins.configs.luasnip")(plugin, opts)
      local luasnip = require("luasnip")
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },

  {
    "andweeb/presence.nvim",
    config = function()
      require("presence"):setup({
        auto_update = true,
        neovim_image_text = "Neovim IDE",
        main_image = "file",
        debounce_timeout = 10,
        editing_text = "Editing %s",
        file_explorer_text = "Browsing %s",
        git_commit_text = "Committing changes",
        plugin_manager_text = "Managing plugins",
        reading_text = "Reading %s",
        workspace_text = "Working on %s",
        line_number_text = "Line %s/%s",
      })
    end,
  },

  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      opts.section.header.val = {
        "███████╗██╗  ██╗ █████╗ ██╗     ███████╗███████╗",
        "██╔════╝██║ ██╔╝██╔══██╗██║     ██╔════╝██╔════╝",
        "███████╗█████╔╝ ███████║██║     ███████╗█████╗  ",
        "╚════██║██╔═██╗ ██╔══██║██║     ╚════██║██╔══╝  ",
        "███████║██║  ██╗██║  ██║███████╗███████║███████╗",
        "╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝",
      }
      return opts
    end,
  },

  { "max397574/better-escape.nvim", enabled = true },

  {
    "Exafunction/codeium.vim",
    event = "BufEnter",
  },

  {
    "ThePrimeagen/vim-be-good",
    cmd = "VimBeGood", 
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", 
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          follow_current_file = true,
          hijack_netrw = true,
          use_libuv_file_watcher = true,
        },
        buffers = {
          follow_current_file = true,
        },
        git_status = {
          window = {
            position = "float",
          },
        },
      })
    end,
  },

  {
    "phaazon/hop.nvim",
    branch = "v2", 
    config = function()
      local hop = require("hop")
      hop.setup({ keys = "etovxqpdygfblzhckisuran" }) 

      vim.keymap.set("n", "<leader>fs", function()
        hop.hint_char1({ current_line_only = true })
      end, { desc = "Hop to symbol in current line" })

      vim.keymap.set("n", "<leader>fl", function()
        hop.hint_lines()
      end, { desc = "Hop to line in current window" })

      vim.keymap.set("n", "<leader>fw", function()
        hop.hint_words()
      end, { desc = "Hop to word in current window" })

      vim.keymap.set("n", "<leader>fp", function()
        hop.hint_patterns()
      end, { desc = "Hop to pattern in current window" })
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-file-browser.nvim" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        extensions = {
          file_browser = {
            hijack_netrw = true,
            mappings = {
              ["n"] = {
                ["m"] = require("telescope").extensions.file_browser.actions.move,
              },
            },
          },
        },
      })
      telescope.load_extension("file_browser")

      vim.keymap.set("n", "<leader>fb", ":Telescope file_browser<CR>", { desc = "Open File Browser" })
    end,
  },
}

