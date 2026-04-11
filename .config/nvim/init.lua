-- Ensure dotnet tools are in PATH and runtime is findable
vim.env.PATH = vim.env.HOME .. '/.dotnet/tools:' .. vim.env.PATH
vim.env.DOTNET_ROOT = '/usr/lib/dotnet'

-- Source existing vimrc (keymaps, settings, etc.)
vim.cmd('source ~/.vimrc')

-- Disable syntastic and supertab in neovim (replaced by LSP + nvim-cmp)
vim.g.syntastic_mode_map = { mode = 'passive' }
vim.g.loaded_supertab = 1

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- Treesitter: modern syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    tag = 'v0.9.3',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { 'c_sharp', 'typescript', 'tsx', 'javascript', 'lua', 'vim', 'vimdoc', 'json', 'yaml', 'xml', 'bash', 'sql' },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    tag = 'v2.3.0',
    config = function()
      local lspconfig = require('lspconfig')
      -- C# is handled by seblj/roslyn.nvim (Microsoft's official Roslyn LSP)

      -- TypeScript/JavaScript language server (install with: npm i -g typescript-language-server typescript)
      lspconfig.ts_ls.setup{}

      -- Keymaps for LSP (only active when LSP attaches)
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

          -- Disable LSP semantic token highlighting (let treesitter handle it)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client.server_capabilities.semanticTokensProvider then
            client.server_capabilities.semanticTokensProvider = nil
          end
        end,
      })
    end,
  },

  -- Mason: LSP/tool installer (used to install roslyn for C#)
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup({
        registries = {
          'github:mason-org/mason-registry',
          'github:Crashdummyy/mason-registry',
        },
      })
    end,
  },

  -- C# LSP via Microsoft's Roslyn Language Server
  -- Auto-installs the `roslyn` mason package on first .cs file open.
  {
    'seblj/roslyn.nvim',
    ft = 'cs',
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      local mr = require('mason-registry')
      if not mr.is_installed('roslyn') then
        vim.notify('Installing roslyn LSP via mason...', vim.log.levels.INFO)
        vim.cmd('MasonInstall roslyn')
      end
      require('roslyn').setup({})
    end,
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        }),
      })

      -- Add vim-dadbod-completion for SQL filetypes
      cmp.setup.filetype({ 'sql', 'mysql', 'plsql' }, {
        sources = cmp.config.sources({
          { name = 'vim-dadbod-completion' },
        }, {
          { name = 'buffer' },
        }),
      })
    end,
  },

  -- Telescope (fuzzy finder, replaces ctrlp)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    lazy = false,
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<C-p>', '<cmd>Telescope find_files<cr>' },
      { '<C-g>', '<cmd>Telescope live_grep<cr>' },
      { '<leader>fb', '<cmd>Telescope buffers<cr>' },
    },
  },

  -- Render markdown inline
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },

  -- Database (vim-dadbod)
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      'tpope/vim-dadbod',
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' } },
    },
    cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
    keys = {
      { '<leader>db', '<cmd>DBUIToggle<cr>', desc = 'Toggle DB UI' },
    },
    init = function()
      vim.g.db_ui_use_nerd_font_icons = 1
      vim.g.db_ui_execute_on_save = 0
    end,
    config = function()
      -- Ctrl+Enter to execute query (normal: whole buffer, visual: selection)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'sql', 'mysql', 'plsql', 'dbout' },
        callback = function()
          vim.keymap.set('n', '<F5>', '<Plug>(DBUI_ExecuteQuery)', { buffer = true })
          vim.keymap.set('v', '<F5>', '<Plug>(DBUI_ExecuteQuery)', { buffer = true })
        end,
      })
    end,
  },

  -- File icons (used by lualine, telescope, nerdtree, etc.)
  { 'nvim-tree/nvim-web-devicons' },

  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'gruvbox',
          section_separators = '',
          component_separators = '|',
        },
        sections = {
          lualine_c = {
            { 'filename', path = 1 },
          },
        },
      })
    end,
  },

  -- Git signs in the gutter
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end,
  },

  -- Indent guides
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    config = function()
      require('ibl').setup({
        indent = { char = '|' },
        scope = { enabled = true },
      })
    end,
  },

  -- Keep your existing pathogen plugins working in neovim
  { 'tpope/vim-fugitive' },
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local function on_attach(bufnr)
        local api = require('nvim-tree.api')
        api.config.mappings.default_on_attach(bufnr)
        local opts = { buffer = bufnr, noremap = true, silent = true }
        vim.keymap.set('n', 's', api.node.open.vertical, opts)
        vim.keymap.set('n', 'i', api.node.open.horizontal, opts)
        vim.keymap.set('n', '<CR>', api.node.open.no_window_picker, opts)
        vim.keymap.set('n', 'o', api.node.open.no_window_picker, opts)
        -- Default <C-x> is horizontal-split-open, which we've rebound to `i`.
        -- Unmap it so the global <C-x><C-x> → :qa mapping (from .vimrc) fires
        -- inside the tree instead of being shadowed by the buffer-local <C-x>.
        pcall(vim.keymap.del, 'n', '<C-x>', { buffer = bufnr })
      end
      require('nvim-tree').setup({
        on_attach = on_attach,
        view = {
          width = 50,
          number = true,
          relativenumber = true,
        },
        actions = {
          open_file = {
            quit_on_open = false,
          },
        },
        git = {
          enable = true,
          ignore = false,
        },
        renderer = {
          highlight_git = "name",
          icons = {
            git_placement = "after",
          },
        },
      })
      vim.keymap.set('n', '<C-k><C-b>', '<cmd>NvimTreeToggle<cr>')
      vim.keymap.set('n', '<C-k><C-h>', '<cmd>NvimTreeFocus<cr>')
      vim.keymap.set('n', '<C-k><C-f>', '<cmd>NvimTreeFindFile<cr>')
    end,
  },
  { 'Raimondi/delimitMate' },
  -- { 'easymotion/vim-easymotion' },
  { 'mg979/vim-visual-multi' },  -- modern replacement for vim-multiple-cursors
  { 'ellisonleao/gruvbox.nvim' },
  { 'github/copilot.vim' },
})

-- Norwegian keyboard: AltGr+ø → { and AltGr+æ → } (AltGr produces ö/ä)
vim.keymap.set('i', 'ö', '{')
vim.keymap.set('i', 'ä', '}')
vim.keymap.set('n', 'ö', '{')
vim.keymap.set('n', 'ä', '}')
vim.keymap.set('v', 'ö', '{')
vim.keymap.set('v', 'ä', '}')

-- Disable line wrapping
vim.opt.wrap = false

-- Auto-reload files changed on disk
vim.o.autoread = true
vim.api.nvim_create_autocmd({'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI'}, {
  command = 'checktime',
})

vim.o.termguicolors = true

-- Re-apply gruvbox after lazy loads it
require('gruvbox').setup({
  transparent_mode = true,
  contrast = "soft",
  overrides = {
    String = { fg = "#dbb68a", bg = "NONE" },
    Comment = { fg = "#a89984", bg = "NONE" },
    ["@string"] = { fg = "#dbb68a", bg = "NONE" },
    ["@comment"] = { fg = "#a89984", bg = "NONE" },
  },
})
vim.cmd('colorscheme gruvbox')

-- Build with :make — auto-detect makeprg based on project files
vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup('SetMakeprg', { clear = true }),
  callback = function()
    if vim.fn.glob('*.sln') ~= '' or vim.fn.glob('*.csproj') ~= '' then
      vim.opt_local.makeprg = 'dotnet build'
    elseif vim.fn.filereadable('package.json') == 1 then
      vim.opt_local.makeprg = 'npm run build'
    elseif vim.fn.filereadable('Makefile') == 1 then
      vim.opt_local.makeprg = 'make'
    end
  end,
})

vim.keymap.set('n', '<leader>b', ':make!<CR>', { desc = 'Build project' })
vim.keymap.set('n', '<leader>t', function()
  if vim.fn.glob('*.sln') ~= '' or vim.fn.glob('*.csproj') ~= '' then
    vim.cmd('!dotnet test')
  elseif vim.fn.filereadable('package.json') == 1 then
    vim.cmd('!npm test')
  elseif vim.fn.filereadable('pytest.ini') == 1 or vim.fn.filereadable('setup.py') == 1 or vim.fn.filereadable('pyproject.toml') == 1 then
    vim.cmd('!pytest')
  end
end, { desc = 'Run tests' })

vim.keymap.set('n', '<leader>lg', function()
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = math.floor(vim.o.columns * 0.9),
    height = math.floor(vim.o.lines * 0.9),
    col = math.floor(vim.o.columns * 0.05),
    row = math.floor(vim.o.lines * 0.05),
    style = 'minimal',
    border = 'rounded',
  })
  vim.fn.termopen('lazygit', {
    on_exit = function()
      if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
      if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end
    end,
  })
  vim.cmd('startinsert')
end, { desc = 'Open lazygit' })
