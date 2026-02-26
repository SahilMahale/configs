vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.signcolumn = "yes"
vim.o.wrap = false
vim.g.mapleader = ' '
vim.o.winborder = 'rounded'
-- Search behavior
vim.o.hlsearch = true   -- Enable search highlighting
vim.o.incsearch = true  -- Show matches as you type
vim.o.ignorecase = true -- Case insensitive search
vim.o.smartcase = true  -- Case sensitive if uppercase present
vim.o.wrapscan = true   -- Search wraps around the file
vim.o.magic = true      -- Use magic patterns in search
-- base keymaps
vim.keymap.set('n', '<leader>w', ':w<cr>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>qq', ':wq<cr>', { desc = 'Save and quit' })
vim.keymap.set('n', '<leader>q!', ':q!<cr>', { desc = 'Force quit' })
vim.keymap.set('n', '<leader>qr', ':<cmd>restart <cr>', { desc = 'Restart nvim' })
vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<Esc>:w<cr>', { desc = 'Save and gotonormal mode' })
vim.keymap.set('n', '<leader>o', ':update<cr> :source<cr>', { desc = 'Update and source file' })
-- Copy to system clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'Copy to system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>d', '"+d', { desc = 'Delete to system clipboard' })
vim.keymap.set('n', '<leader>D', '"+D', { desc = 'Delete line to system clipboard' })
vim.keymap.set('n', '<leader>Y', '"+Y', { desc = 'Copy line to system clipboard' })

-- Paste from system clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>P', '"+P', { desc = 'Paste before from system clipboard' })
vim.keymap.set('n', '<leader>tW', function()
    vim.opt.wrap = not vim.opt.wrap:get()
    local status = vim.opt.wrap:get() and "ON" or "OFF"
    vim.notify("Text wrap: " .. status, vim.log.levels.INFO)
end, { desc = 'Toggle text wrap' })


-- Install packages (opt = false loads them automatically on startup)
vim.pack.add({
    { src = "https://github.com/vague2k/vague.nvim",                          opt = false },
    { src = "https://github.com/EdenEast/nightfox.nvim",                      opt = false },
    { src = "https://github.com/neovim/nvim-lspconfig",                       opt = false },
    { src = "https://github.com/folke/snacks.nvim",                           opt = false },
    { src = "https://github.com/echasnovski/mini.nvim",                       opt = false },
    { src = "https://github.com/folke/which-key.nvim",                        opt = false },
    { src = "https://github.com/nvim-tree/nvim-web-devicons",                 opt = false },
    { src = "https://github.com/lewis6991/gitsigns.nvim",                     opt = false },
    { src = "https://github.com/romgrk/barbar.nvim",                          opt = false },
    { src = "https://github.com/nvim-lualine/lualine.nvim",                   opt = false },
    { src = "https://github.com/rmagatti/auto-session",                       opt = false },
    { src = "https://github.com/numToStr/Comment.nvim",                       opt = false },
    { src = "https://github.com/mason-org/mason.nvim",                        opt = false },
    { src = "https://github.com/mason-org/mason-lspconfig.nvim",              opt = false },
    { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",   opt = false },
    { src = "https://github.com/folke/noice.nvim",                            opt = false },
    { src = "https://github.com/MunifTanjim/nui.nvim",                        opt = false },
    { src = "https://github.com/rafamadriz/friendly-snippets",                opt = false },
    { src = "https://github.com/saghen/blink.cmp",                            opt = false },
    { src = "https://github.com/iamcco/markdown-preview.nvim",                opt = false },
    { src = "https://github.com/nvimdev/dashboard-nvim",                      opt = false },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter",             opt = false },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", opt = false },
    { src = "https://github.com/nvim-lua/plenary.nvim",                       opt = false },
    { src = "https://github.com/nvim-telescope/telescope.nvim",               opt = false },
    { src = "https://github.com/piersolenski/import.nvim",                    opt = false },
})

-- Load all plugins from opt directory
-- (This is needed because vim.pack.add with opt=false only affects NEW installs)
local plugins_to_load = {
    'snacks.nvim', 'dashboard-nvim', 'telescope.nvim', 'plenary.nvim',
    'nvim-treesitter', 'nvim-treesitter-textobjects', 'mini.nvim',
    'which-key.nvim', 'gitsigns.nvim', 'barbar.nvim', 'lualine.nvim',
    'auto-session', 'Comment.nvim', 'noice.nvim', 'nui.nvim', 'blink.cmp',
    'friendly-snippets', 'nvim-web-devicons', 'import.nvim',
    'markdown-preview.nvim', 'nightfox.nvim',
    'mason.nvim', 'mason-lspconfig.nvim', 'mason-tool-installer.nvim', 'nvim-lspconfig'
}

for _, plugin in ipairs(plugins_to_load) do
    vim.cmd('packadd ' .. plugin)
end

-- Keep markdown preview open when switching buffers
vim.g.mkdp_auto_close = 0

-- Check if oil is available before setting it up
local ok, oil = pcall(require, "oil")
if not ok then
    vim.notify("Oil plugin not found, skipping setup", vim.log.levels.WARN)
else
    oil.setup({
        -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
        -- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
        default_file_explorer = false,
        -- Id is automatically added at the beginning, and name at the end
        -- See :help oil-columns
        columns = {
            "icon",
            -- "permissions",
            -- "size",
            -- "mtime",
        },
        -- Buffer-local options to use for oil buffers
        buf_options = {
            buflisted = true,
        },
        -- Window-local options to use for oil buffers
        win_options = {
            wrap = false,
            signcolumn = "no",
            cursorcolumn = true,
            foldcolumn = "0",
            spell = false,
            list = false,
            conceallevel = 3,
            concealcursor = "nvic",
        },
        -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
        delete_to_trash = false,
        -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
        skip_confirm_for_simple_edits = false,
        -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
        -- (:help prompt_save_on_select_new_entry)
        prompt_save_on_select_new_entry = true,
        -- Oil will automatically delete hidden buffers after this delay
        -- You can set the delay to false to disable cleanup entirely
        -- Note that the cleanup process only starts when none of the oil buffers are currently displayed
        cleanup_delay_ms = 2000,
        lsp_file_methods = {
            -- Enable or disable LSP file operations
            enabled = true,
            -- Time to wait for LSP file operations to complete before skipping
            timeout_ms = 1000,
            -- Set to true to autosave buffers that are updated with LSP willRenameFiles
            -- Set to "unmodified" to only save unmodified buffers
            autosave_changes = false,
        },
        -- Constrain the cursor to the editable parts of the oil buffer
        -- Set to `false` to disable, or "name" to keep it on the file names
        constrain_cursor = "editable",
        -- Set to true to watch the filesystem for changes and reload oil
        watch_for_changes = false,
        -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
        -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
        -- Additionally, if it is a string that matches "actions.<name>",
        -- it will use the mapping at require("oil.actions").<name>
        -- Set to `false` to remove a keymap
        -- See :help oil-actions for a list of all available actions
        keymaps = {
            ["g?"] = { "actions.show_help", mode = "n" },
            ["<CR>"] = "actions.select",
            ["<C-s>"] = { "actions.select", opts = { vertical = true } },
            ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
            ["<C-t>"] = { "actions.select", opts = { tab = true } },
            ["<C-p>"] = "actions.preview",
            ["<C-c>"] = { "actions.close", mode = "n" },
            ["<C-l>"] = "actions.refresh",
            ["-"] = { "actions.parent", mode = "n" },
            ["_"] = { "actions.open_cwd", mode = "n" },
            ["`"] = { "actions.cd", mode = "n" },
            ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
            ["gs"] = { "actions.change_sort", mode = "n" },
            ["gx"] = "actions.open_external",
            ["g."] = { "actions.toggle_hidden", mode = "n" },
            ["g\\"] = { "actions.toggle_trash", mode = "n" },
        },
        -- Set to false to disable all of the above keymaps
        use_default_keymaps = true,
        view_options = {
            -- Show files and directories that start with "."
            show_hidden = false,
            -- This function defines what is considered a "hidden" file
            is_hidden_file = function(name, bufnr)
                local m = name:match("^%.")
                return m ~= nil
            end,
            -- This function defines what will never be shown, even when `show_hidden` is set
            is_always_hidden = function(name, bufnr)
                return false
            end,
            -- Sort file names with numbers in a more intuitive order for humans.
            -- Can be "fast", true, or false. "fast" will turn it off for large directories.
            natural_order = "fast",
            -- Sort file and directory names case insensitive
            case_insensitive = false,
            sort = {
                -- sort order can be "asc" or "desc"
                -- see :help oil-columns to see which columns are sortable
                { "type", "asc" },
                { "name", "asc" },
            },
            -- Customize the highlight group for the file name
            highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
                return nil
            end,
        },
        -- Extra arguments to pass to SCP when moving/copying files over SSH
        extra_scp_args = {},
        -- EXPERIMENTAL support for performing file operations with git
        git = {
            -- Return true to automatically git add/mv/rm files
            add = function(path)
                return false
            end,
            mv = function(src_path, dest_path)
                return false
            end,
            rm = function(path)
                return false
            end,
        },
        -- Configuration for the floating window in oil.open_float
        float = {
            -- Padding around the floating window
            padding = 2,
            -- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
            max_width = 0,
            max_height = 0,
            border = "rounded",
            win_options = {
                winblend = 0,
            },
            -- optionally override the oil buffers window title with custom function: fun(winid: integer): string
            get_win_title = nil,
            -- preview_split: Split direction: "auto", "left", "right", "above", "below".
            preview_split = "auto",
            -- This is the config that will be passed to nvim_open_win.
            -- Change values here to customize the layout
            override = function(conf)
                return conf
            end,
        },
        -- Configuration for the file preview window
        preview_win = {
            -- Whether the preview window is automatically updated when the cursor is moved
            update_on_cursor_moved = true,
            -- How to open the preview window "load"|"scratch"|"fast_scratch"
            preview_method = "fast_scratch",
            -- A function that returns true to disable preview on a file e.g. to avoid lag
            disable_preview = function(filename)
                return false
            end,
            -- Window-local options to use for preview window buffers
            win_options = {},
        },
        -- Configuration for the floating action confirmation window
        confirmation = {
            -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
            -- min_width and max_width can be a single value or a list of mixed integer/float types.
            -- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
            max_width = 0.9,
            -- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
            min_width = { 40, 0.4 },
            -- optionally define an integer/float for the exact width of the preview window
            width = nil,
            -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
            -- min_height and max_height can be a single value or a list of mixed integer/float types.
            -- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
            max_height = 0.9,
            -- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
            min_height = { 5, 0.1 },
            -- optionally define an integer/float for the exact height of the preview window
            height = nil,
            border = "rounded",
            win_options = {
                winblend = 0,
            },
        },
        -- Configuration for the floating progress window
        progress = {
            max_width = 0.9,
            min_width = { 40, 0.4 },
            width = nil,
            max_height = { 10, 0.9 },
            min_height = { 5, 0.1 },
            height = nil,
            border = "rounded",
            minimized_border = "none",
            win_options = {
                winblend = 0,
            },
        },
        -- Configuration for the floating SSH window
        ssh = {
            border = "rounded",
        },
        -- Configuration for the floating keymaps help window
        keymaps_help = {
            border = "rounded",
        },
    })
end
require('mini.pick').setup()
require('mini.pairs').setup()
require('mini.jump').setup()        -- Quick character jumping
require('mini.jump2d').setup()      -- 2D jumping within visible lines
require('mini.cursorword').setup()  -- Highlight word under cursor
require('mini.hipatterns').setup()  -- Pattern highlighting
require('mini.indentscope').setup() -- Pattern highlighting
require('mini.bracketed').setup({
    file = { suffix = '' },         -- Disable file navigation mappings
})
require('import').setup()

-- Gitsigns setup
require('gitsigns').setup()

-- Treesitter setup
require('nvim-treesitter.configs').setup({
    ensure_installed = { "lua", "javascript", "typescript", "python", "go", "rust", "html", "css", "json", "markdown", "terraform", "hcl" },
    highlight = { enable = true },
    indent = { enable = true },
    textobjects = {
        move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
                ["]f"] = "@function.outer",
                ["]c"] = "@class.outer",
            },
            goto_next_end = {
                ["]F"] = "@function.outer",
                ["]C"] = "@class.outer",
            },
            goto_previous_start = {
                ["[f"] = "@function.outer",
                ["[c"] = "@class.outer",
            },
            goto_previous_end = {
                ["[F"] = "@function.outer",
                ["[C"] = "@class.outer",
            },
        },
    },
})

-- Dashboard setup
require('dashboard').setup({
    theme = 'hyper',
    config = {
        week_header = {
            enable = true,
        },
        shortcut = {
            { desc = '󰊳 Mason', group = '@property', action = 'Mason', key = 'u' },
            {
                icon = ' ',
                icon_hl = '@variable',
                desc = 'Files',
                group = 'Label',
                action = 'lua require("snacks").picker.files()',
                key = 'f',
            },
            {
                desc = ' Recent',
                group = 'Number',
                action = 'lua require("snacks").picker.recent()',
                key = 'r',
            },
            {
                desc = ' Config',
                group = 'DiagnosticHint',
                action = 'edit $MYVIMRC',
                key = 'c',
            },
            {
                desc = ' Quit',
                group = 'DiagnosticError',
                action = 'qa',
                key = 'q',
            },
        },
    },
})

require('Comment').setup()

-- Blink.cmp setup
require('blink.cmp').setup({
    fuzzy = {
        implementation = 'lua'
    },
    keymap = {
        preset = 'default',
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-@>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-a>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide' },
        ['<C-y>'] = { 'select_and_accept' },
        ['<CR>'] = { 'select_and_accept', 'fallback' },

        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<C-n>'] = { 'select_next', 'fallback' },

        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

        ['<Tab>'] = { 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
    },

    appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
    },

    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    completion = {
        accept = { auto_brackets = { enabled = true } },
        menu = {
            draw = {
                treesitter = { "lsp" }
            }
        },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 500,
        }
    },

    signature = { enabled = true }
})

-- Noice setup for better command line
require('noice').setup({
    lsp = {
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
        },
    },
    presets = {
        bottom_search = true,         -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false,       -- add a border to hover docs and signature help
    },
})

-- Local reference to snacks for cleaner code
local snacks = require('snacks')

require('lualine').setup({
    options = {
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
})


snacks.setup({
    -- Enable features you want
    animate = { enabled = true },
    scratch = { enabled = true },
    bigfile = { enabled = true },

    picker = {
        enabled = true,
    },
    explorer = {
        enabled = true,
    },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = {
        enabled = true,
        animate = {
            duration = 0, -- Instant notifications for performance
        },
    },
    quickfile = { enabled = true },
    lazygit = { enabled = true },
    scroll = {
        enabled = true,
        animate = {
            duration = {
                step = 10,     -- Shorter steps for performance
                total = 150,   -- Shorter total duration
            },
            easing = "linear", -- Linear is most performant
        },
        spamming = 5,          -- Lower spamming threshold
    },
    statuscolumn = { enabled = true },
    words = { enabled = false },
})

require('which-key').setup({
    win = {
        border = "rounded",
    },
})

require('barbar').setup({
    animation = true,
    auto_hide = false,
    tabpages = true,
    clickable = true,
    focus_on_close = 'previous',
    highlight_alternate = false,
    highlight_inactive_file_icons = false,
    highlight_visible = true,
    icons = {
        buffer_index = true,
        buffer_number = false,
        button = '',
        diagnostics = {
            [vim.diagnostic.severity.ERROR] = { enabled = true, icon = 'E' },
            [vim.diagnostic.severity.WARN] = { enabled = false },
            [vim.diagnostic.severity.INFO] = { enabled = false },
            [vim.diagnostic.severity.HINT] = { enabled = true },
        },
        gitsigns = {
            added = { enabled = true, icon = '+' },
            changed = { enabled = true, icon = '~' },
            deleted = { enabled = true, icon = '-' },
        },
        filetype = {
            custom_colors = false,
            enabled = true,
        },
        separator = { left = '▎', right = '' },
        separator_at_end = true,
        modified = { button = '●' },
        pinned = { button = '', filename = true },
        preset = 'default',
        alternate = { filetype = { enabled = false } },
        current = { buffer_index = true },
        inactive = { button = '×' },
        visible = { modified = { buffer_number = false } },
    },
})

-- Auto-session configuration
require('auto-session').setup({
    log_level = "error",
    auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    auto_session_use_git_branch = false,
    auto_session_enable_last_session = false,
    auto_session_root_dir = vim.fn.stdpath('data') .. "/sessions/",
    auto_session_enabled = true,
    auto_save_enabled = nil,
    auto_restore_enabled = nil,
    auto_session_create_enabled = nil,
})

-- Git Signs config
local gitS = require('gitsigns')
gitS.setup({
    current_line_blame = false
})
-- keymaps for plugins
vim.keymap.set('n', '<leader>e', function() snacks.explorer() end, { desc = 'Toggle file explorer' })
vim.keymap.set('n', '<leader> ', function() snacks.picker.files() end, { desc = 'Find files' })
vim.keymap.set('n', '<leader>/', function() snacks.picker.grep() end, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>,', function() snacks.picker.buffers() end, { desc = 'Show open buffers' })
vim.keymap.set('n', '<leader>n', function() snacks.notifier.show_history() end, { desc = 'Open notification center' })
vim.keymap.set('n', '<leader>.', function() snacks.scratch() end, { desc = 'Toggle a Scratch Buffer' })
vim.keymap.set('n', '<leader>S', function() snacks.scratch.select() end, { desc = 'Toggle a Scratch Buffer' })
vim.keymap.set('n', '<leader>gg', function() snacks.lazygit() end, { desc = 'Open lazygit' })
vim.keymap.set('n', '<leader>gb', function() gitS.toggle_current_line_blame() end, { desc = 'Toggle Git Blame' })
vim.keymap.set('n', '<leader>h', ':Pick help<cr>', { desc = 'Help for neovim commmand, functions etc.' })
vim.keymap.set('n', 's', '<Cmd>lua require("mini.jump").jump()<CR>', { desc = 'Jump to character' })
vim.keymap.set('n', '<leader>j', '<Cmd>lua require("mini.jump2d").start()<CR>',
    { desc = '2D jump to any visible location' })

-- Clear search highlighting on Escape
vim.keymap.set('n', '<Esc>', '<Cmd>nohlsearch<CR>', { desc = 'Clear search highlighting' })
vim.keymap.set('n', '<leader>qs', '<Cmd>SessionRestore<CR>', { desc = 'Restore session' })
vim.keymap.set('n', '<leader>qd', '<Cmd>SessionDelete<CR>', { desc = 'Delete session' })

-- Window navigation keymaps
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Focus left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Focus down window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Focus up window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Focus right window' })

-- Barbar keymaps
vim.keymap.set('n', '<S-h>', '<Cmd>BufferPrevious<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<S-l>', '<Cmd>BufferNext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>bb', '<Cmd>BufferPick<CR>', { desc = 'Pick buffer' })
vim.keymap.set('n', '<leader>bd', '<Cmd>BufferPickDelete<CR>', { desc = 'Pick buffer to close' })
vim.keymap.set('n', '<leader>bc', '<Cmd>BufferClose<CR>', { desc = 'Close buffer' })
vim.keymap.set('n', '<leader>bh', '<Cmd>BufferCloseBuffersLeft<CR>', { desc = 'Close buffer on Left' })
vim.keymap.set('n', '<leader>bl', '<Cmd>BufferCloseBuffersRight<CR>', { desc = 'Close buffer on Right' })
vim.keymap.set('n', '<leader>bac', '<Cmd>BufferCloseAllButCurrent<CR>', { desc = 'Close buffer all but current' })
vim.keymap.set('n', '<leader>baC', '<Cmd>BufferCloseAllButCurrentOrPinned<CR>', { desc = 'Close buffer all but current or pinned' })
vim.keymap.set('n', '<leader>bap', '<Cmd>BufferCloseAllButPinned<CR>', { desc = 'Close buffer all but pinned' })
vim.keymap.set('n', '<leader>bav', '<Cmd>BufferCloseAllButVisible<CR>', { desc = 'Close buffer all but visible' })
vim.keymap.set('n', '<leader>bp', '<Cmd>BufferPin<CR>', { desc = 'Pin buffer' })
vim.keymap.set('n', '<leader>b1', '<Cmd>BufferGoto 1<CR>', { desc = 'Go to buffer 1' })
vim.keymap.set('n', '<leader>b2', '<Cmd>BufferGoto 2<CR>', { desc = 'Go to buffer 2' })
vim.keymap.set('n', '<leader>b3', '<Cmd>BufferGoto 3<CR>', { desc = 'Go to buffer 3' })
vim.keymap.set('n', '<leader>b4', '<Cmd>BufferGoto 4<CR>', { desc = 'Go to buffer 4' })
vim.keymap.set('n', '<leader>b5', '<Cmd>BufferGoto 5<CR>', { desc = 'Go to buffer 5' })
vim.keymap.set('n', '<leader>b6', '<Cmd>BufferGoto 6<CR>', { desc = 'Go to buffer 6' })
vim.keymap.set('n', '<leader>b7', '<Cmd>BufferGoto 7<CR>', { desc = 'Go to buffer 7' })
vim.keymap.set('n', '<leader>b8', '<Cmd>BufferGoto 8<CR>', { desc = 'Go to buffer 8' })
vim.keymap.set('n', '<leader>b9', '<Cmd>BufferGoto 9<CR>', { desc = 'Go to buffer 9' })
vim.keymap.set('n', '<leader>b0', '<Cmd>BufferLast<CR>', { desc = 'Go to last buffer' })
vim.keymap.set('n', '<leader>bH', '<Cmd>BufferMovePrevious<CR>', { desc = 'Move buffer left' })
vim.keymap.set('n', '<leader>bL', '<Cmd>BufferMoveNext<CR>', { desc = 'Move buffer right' })
vim.keymap.set('n', '<leader>bo1', '<Cmd>BufferOrderByBufferNumber<CR>', { desc = 'Order buffers by number' })
vim.keymap.set('n', '<leader>bo2', '<Cmd>BufferOrderByDirectory<CR>', { desc = 'Order buffers by directory' })
vim.keymap.set('n', '<leader>bo3', '<Cmd>BufferOrderByLanguage<CR>', { desc = 'Order buffers by language' })
vim.keymap.set('n', '<leader>bo4', '<Cmd>BufferOrderByWindowNumber<CR>', { desc = 'Order buffers by window number' })
vim.keymap.set('n', '<A-p>m', '<Cmd>MarkdownPreviewToggle<CR>', { desc = 'Toggle MarkDown preview' })

-- Terminal keymaps with custom config
vim.keymap.set("n", "<C-/>", function()
    snacks.terminal.toggle(nil, {
        win = {
            position = "bottom",
            height = 0.3,
            border = "rounded",
            title = " Terminal ",
            title_pos = "center",
        },
        autoclose = true,
    })
end, { desc = "Toggle Terminal" })

vim.keymap.set("n", "<C-S-/>", function()
    snacks.terminal.open(nil, {
        win = {
            position = "bottom",
            height = 0.3,
            border = "rounded",
            title = " Terminal ",
            title_pos = "center",
        },
        autoclose = true,
    })
end, { desc = "New Terminal" })

-- Terminal mode keymaps
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("t", "<C-/>", function()
    snacks.terminal.toggle(nil, {
        win = {
            position = "bottom",
            height = 0.3,
            border = "rounded",
            title = " Terminal ",
            title_pos = "center",
        },
        autoclose = true,
    })
end, { desc = "Toggle Terminal" })


--LSP config
-- Add nvm's current node/npm to PATH for Mason
local function setup_nvm_path()
    -- Try to get current nvm version
    local handle = io.popen("bash -c 'source ~/.nvm/nvm.sh && nvm current'")
    if handle then
        local current_version = handle:read("*a"):gsub("%s+", "")
        handle:close()
        if current_version and current_version ~= "" and current_version ~= "none" then
            local nvm_node_path = vim.fn.expand("$HOME/.nvm/versions/node/" .. current_version .. "/bin")
            if vim.fn.isdirectory(nvm_node_path) == 1 then
                vim.env.PATH = nvm_node_path .. ":" .. vim.env.PATH
                return true
            end
        end
    end
    -- Fallback: try to find any node in nvm
    local nvm_versions_dir = vim.fn.expand("$HOME/.nvm/versions/node")
    if vim.fn.isdirectory(nvm_versions_dir) == 1 then
        local versions = vim.fn.readdir(nvm_versions_dir)
        if #versions > 0 then
            local latest_version = versions[#versions] -- Get last (likely latest) version
            local nvm_node_path = nvm_versions_dir .. "/" .. latest_version .. "/bin"
            if vim.fn.isdirectory(nvm_node_path) == 1 then
                vim.env.PATH = nvm_node_path .. ":" .. vim.env.PATH
                return true
            end
        end
    end
    return false
end

local nvm_result = setup_nvm_path()
vim.notify("setup_nvm_path returned: " .. tostring(nvm_result), vim.log.levels.INFO)

require("mason").setup({
    PATH = "prepend", -- Ensure mason's bin is in PATH
    -- Add nvm node path
    install_root_dir = vim.fn.stdpath("data") .. "/mason",
})

-- LSP on_attach function for format on save
local on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
            end,
        })
    end
end

-- Setup mason-lspconfig to automatically configure LSP servers
local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if mason_lspconfig_ok then
    mason_lspconfig.setup({
        automatic_installation = true,
        handlers = {
            -- Default handler for all servers
            function(server_name)
                require("lspconfig")[server_name].setup({
                    on_attach = on_attach,
                })
            end,
            -- Special configuration for lua_ls
            ["lua_ls"] = function()
                require("lspconfig").lua_ls.setup({
                    on_attach = on_attach,
                    settings = {
                        Lua = {
                            runtime = {
                                version = 'LuaJIT',
                            },
                            diagnostics = {
                                globals = { 'vim', 'require' },
                            },
                            workspace = {
                                library = vim.api.nvim_get_runtime_file("", true),
                            },
                            telemetry = {
                                enable = false,
                            },
                        },
                    },
                })
            end,
        },
    })
else
    vim.notify("mason-lspconfig not found. Please run :MasonInstall to install LSP servers.", vim.log.levels.WARN)
end

require("mason-tool-installer").setup({
    ensure_installed = {
        "ts_ls",
        "html",
        "cssls",
        "tailwindcss",
        "lua_ls",
        "emmet_ls",
        "gopls",
        "pyright",
        "markdown_oxide",
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
        "eslint",
        "dockerls",
        "docker_compose_language_service",
        "jsonls",
        "jqls",
        "vtsls",
    },
    auto_update = false,
    run_on_start = true,
})

-- LSP keymaps
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, { desc = 'LSP Format buffer' })
vim.keymap.set('n', 'gd', function() snacks.picker.lsp_definitions() end, { desc = 'Go to definition' })
vim.keymap.set('n', 'gr', function() snacks.picker.lsp_references() end, { desc = 'Go to references' })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Show hover documentation' })
vim.keymap.set('n', '<leader>k', vim.lsp.buf.signature_help, { desc = 'Show signature help' })
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>rn', vim.lsp.buf.rename, { desc = 'LSP rename a function or variable' })
-- inbuilt nvim autocomplete
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        end
    end,
})
vim.cmd("set completeopt+=noselect")
-- Color theme
vim.cmd("colorscheme carbonfox")
