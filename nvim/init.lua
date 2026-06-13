-- Options & keymaps (must come before lazy bootstrap)
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.signcolumn = "yes"
vim.o.wrap = false
vim.g.mapleader = ' '
vim.o.winborder = 'rounded'
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.wrapscan = true
vim.o.magic = true

-- base keymaps
vim.keymap.set('n', '<leader>w', ':w<cr>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>qq', ':wq<cr>', { desc = 'Save and quit' })
vim.keymap.set('n', '<leader>q!', ':q!<cr>', { desc = 'Force quit' })
vim.keymap.set('n', '<leader>qr', ':<cmd>restart <cr>', { desc = 'Restart nvim' })
vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<Esc>:w<cr>', { desc = 'Save and go to normal mode' })
vim.keymap.set('n', '<leader>o', ':update<cr> :source<cr>', { desc = 'Update and source file' })
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'Copy to system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>d', '"+d', { desc = 'Delete to system clipboard' })
vim.keymap.set('n', '<leader>D', '"+D', { desc = 'Delete line to system clipboard' })
vim.keymap.set('n', '<leader>Y', '"+Y', { desc = 'Copy line to system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>P', '"+P', { desc = 'Paste before from system clipboard' })
vim.keymap.set('n', '<leader>tW', function()
    local wrap = not vim.wo.wrap
    vim.wo.wrap = wrap
    vim.wo.linebreak = wrap
    vim.notify("Text wrap: " .. (wrap and "ON" or "OFF"), vim.log.levels.INFO)
end, { desc = 'Toggle text wrap' })

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- Colorschemes (load immediately so there's no flash)
    { "vague2k/vague.nvim",         lazy = false, priority = 1000 },
    { "EdenEast/nightfox.nvim",     lazy = false, priority = 1000 },
    {
        "nyoom-engineering/oxocarbon.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd("colorscheme oxocarbon")
        end,
    },

    -- Snacks must load early (notifier, picker, etc. are used by other plugins)
    {
        "folke/snacks.nvim",
        lazy = false,
        priority = 900,
        config = function()
            require('snacks').setup({
                animate    = { enabled = true },
                scratch    = { enabled = true },
                bigfile    = { enabled = true },
                picker     = { enabled = true },
                explorer   = { enabled = true },
                indent     = { enabled = true },
                input      = { enabled = true },
                notifier   = {
                    enabled = true,
                    animate = { duration = 0 },
                },
                quickfile  = { enabled = true },
                lazygit    = { enabled = true },
                scroll     = {
                    enabled = true,
                    animate = {
                        duration = { step = 10, total = 150 },
                        easing = "linear",
                    },
                    spamming = 5,
                },
                statuscolumn = { enabled = true },
                words        = { enabled = false },
            })
        end,
    },

    -- Dashboard (needs lazy=false so it shows on startup)
    {
        "nvimdev/dashboard-nvim",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require('dashboard').setup({
                theme = 'hyper',
                config = {
                    week_header = { enable = true },
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
        end,
    },

    -- Auto-session restores on startup so must not be lazy
    {
        "rmagatti/auto-session",
        lazy = false,
        config = function()
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
        end,
    },

    -- Icons (depended on by many plugins)
    { "nvim-tree/nvim-web-devicons", lazy = true },
    { "nvim-lua/plenary.nvim",       lazy = true },
    { "MunifTanjim/nui.nvim",        lazy = true },

    -- Treesitter (load after files open)
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
        config = function()
            -- Enable built-in treesitter highlighting for all filetypes
            vim.api.nvim_create_autocmd('FileType', {
                callback = function(ev) pcall(vim.treesitter.start, ev.buf) end,
            })
            -- Re-apply to buffers already open before treesitter loaded (e.g. session restore)
            vim.defer_fn(function()
                for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                    if vim.api.nvim_buf_is_loaded(buf) then
                        pcall(vim.treesitter.start, buf)
                    end
                end
            end, 100)
            -- Auto-install parsers on first load
            vim.api.nvim_create_autocmd('VimEnter', {
                once = true,
                callback = function()
                    require('nvim-treesitter').install({
                        "lua", "javascript", "typescript", "tsx", "jsx", "python", "go",
                        "rust", "html", "css", "json", "markdown", "terraform", "hcl"
                    })
                end,
            })
            -- Textobject keymaps
            local ts_move = require('nvim-treesitter-textobjects.move')
            vim.keymap.set({ 'n', 'x', 'o' }, ']f', function() ts_move.goto_next_start('@function.outer') end, { desc = 'Next function start' })
            vim.keymap.set({ 'n', 'x', 'o' }, ']c', function() ts_move.goto_next_start('@class.outer') end, { desc = 'Next class start' })
            vim.keymap.set({ 'n', 'x', 'o' }, ']F', function() ts_move.goto_next_end('@function.outer') end, { desc = 'Next function end' })
            vim.keymap.set({ 'n', 'x', 'o' }, ']C', function() ts_move.goto_next_end('@class.outer') end, { desc = 'Next class end' })
            vim.keymap.set({ 'n', 'x', 'o' }, '[f', function() ts_move.goto_previous_start('@function.outer') end, { desc = 'Prev function start' })
            vim.keymap.set({ 'n', 'x', 'o' }, '[c', function() ts_move.goto_previous_start('@class.outer') end, { desc = 'Prev class start' })
            vim.keymap.set({ 'n', 'x', 'o' }, '[F', function() ts_move.goto_previous_end('@function.outer') end, { desc = 'Prev function end' })
            vim.keymap.set({ 'n', 'x', 'o' }, '[C', function() ts_move.goto_previous_end('@class.outer') end, { desc = 'Prev class end' })
        end,
    },
    { "nvim-treesitter/nvim-treesitter-textobjects", lazy = true },

    -- Completion (only needed in insert mode)
    {
        "saghen/blink.cmp",
        event = "InsertEnter",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            require('blink.cmp').setup({
                fuzzy = { implementation = 'lua' },
                keymap = {
                    preset = 'default',
                    ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
                    ['<C-@>']     = { 'show', 'show_documentation', 'hide_documentation' },
                    ['<C-a>']     = { 'show', 'show_documentation', 'hide_documentation' },
                    ['<C-e>']     = { 'hide' },
                    ['<C-y>']     = { 'select_and_accept' },
                    ['<CR>']      = { 'select_and_accept', 'fallback' },
                    ['<C-p>']     = { 'select_prev', 'fallback' },
                    ['<C-n>']     = { 'select_next', 'fallback' },
                    ['<C-b>']     = { 'scroll_documentation_up', 'fallback' },
                    ['<C-f>']     = { 'scroll_documentation_down', 'fallback' },
                    ['<Tab>']     = { 'snippet_forward', 'fallback' },
                    ['<S-Tab>']   = { 'snippet_backward', 'fallback' },
                },
                appearance = {
                    use_nvim_cmp_as_default = true,
                    nerd_font_variant = 'mono',
                },
                sources = {
                    default = { 'lsp', 'path', 'snippets', 'buffer' },
                },
                completion = {
                    accept = { auto_brackets = { enabled = true } },
                    menu = { draw = { treesitter = { "lsp" } } },
                    documentation = {
                        auto_show = true,
                        auto_show_delay_ms = 500,
                    },
                },
                signature = { enabled = true },
            })
        end,
    },
    { "rafamadriz/friendly-snippets", lazy = true },

    -- LSP stack (deferred until after startup)
    {
        "mason-org/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
        config = function()
            require("mason").setup({
                PATH = "prepend",
                install_root_dir = vim.fn.stdpath("data") .. "/mason",
            })
        end,
    },
    {
        "mason-org/mason-lspconfig.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        config = function()
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

            require("mason-lspconfig").setup({
                automatic_installation = true,
                handlers = {
                    function(server_name)
                        require("lspconfig")[server_name].setup({ on_attach = on_attach })
                    end,
                    ["lua_ls"] = function()
                        require("lspconfig").lua_ls.setup({
                            on_attach = on_attach,
                            settings = {
                                Lua = {
                                    runtime     = { version = 'LuaJIT' },
                                    diagnostics = { globals = { 'vim', 'require' } },
                                    workspace   = { library = vim.api.nvim_get_runtime_file("", true) },
                                    telemetry   = { enable = false },
                                },
                            },
                        })
                    end,
                },
            })
        end,
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "mason-org/mason.nvim" },
        config = function()
            require("mason-tool-installer").setup({
                ensure_installed = {
                    "vtsls", "html", "cssls", "tailwindcss", "lua_ls",
                    "emmet_ls", "gopls", "pyright", "markdown_oxide", "stylua",
                    "shellcheck", "shfmt", "flake8", "eslint", "dockerls",
                    "docker_compose_language_service", "jsonls", "jqls",
                },
                auto_update = false,
                run_on_start = true,
            })
        end,
    },
    { "neovim/nvim-lspconfig", lazy = true },

    -- UI / editing plugins (defer until after startup)
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = { "MunifTanjim/nui.nvim" },
        config = function()
            require('noice').setup({
                lsp = {
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"]                = true,
                        ["cmp.entry.get_documentation"]                  = true,
                    },
                },
                presets = {
                    bottom_search         = true,
                    command_palette       = true,
                    long_message_to_split = true,
                    inc_rename            = false,
                    lsp_doc_border        = false,
                },
            })
        end,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            require('which-key').setup({ win = { border = "rounded" } })
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require('lualine').setup({
                options = {
                    theme = 'auto',
                    component_separators = { left = '', right = '' },
                    section_separators   = { left = '', right = '' },
                    disabled_filetypes   = { statusline = {}, winbar = {} },
                    ignore_focus         = {},
                    always_divide_middle = true,
                    globalstatus         = false,
                    refresh              = { statusline = 1000, tabline = 1000, winbar = 1000 },
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch', 'diff', 'diagnostics' },
                    lualine_c = { 'filename' },
                    lualine_x = { 'encoding', 'fileformat', 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' },
                },
                inactive_sections = {
                    lualine_a = {}, lualine_b = {},
                    lualine_c = { 'filename' },
                    lualine_x = { 'location' },
                    lualine_y = {}, lualine_z = {},
                },
                tabline = {}, winbar = {}, inactive_winbar = {}, extensions = {},
            })
        end,
    },
    {
        "romgrk/barbar.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons", "lewis6991/gitsigns.nvim" },
        config = function()
            require('barbar').setup({
                animation = true,
                auto_hide  = false,
                tabpages   = true,
                clickable   = true,
                focus_on_close = 'previous',
                highlight_alternate         = false,
                highlight_inactive_file_icons = false,
                highlight_visible           = true,
                icons = {
                    buffer_index = true,
                    buffer_number = false,
                    button = '',
                    diagnostics = {
                        [vim.diagnostic.severity.ERROR] = { enabled = true, icon = 'E' },
                        [vim.diagnostic.severity.WARN]  = { enabled = false },
                        [vim.diagnostic.severity.INFO]  = { enabled = false },
                        [vim.diagnostic.severity.HINT]  = { enabled = true },
                    },
                    gitsigns = {
                        added   = { enabled = true, icon = '+' },
                        changed = { enabled = true, icon = '~' },
                        deleted = { enabled = true, icon = '-' },
                    },
                    filetype      = { custom_colors = false, enabled = true },
                    separator     = { left = '▎', right = '' },
                    separator_at_end = true,
                    modified      = { button = '●' },
                    pinned        = { button = '', filename = true },
                    preset        = 'default',
                    alternate     = { filetype = { enabled = false } },
                    current       = { buffer_index = true },
                    inactive      = { button = '×' },
                    visible       = { modified = { buffer_number = false } },
                },
            })
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require('gitsigns').setup({ current_line_blame = false })
        end,
    },
    {
        "numToStr/Comment.nvim",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require('Comment').setup()
        end,
    },
    {
        "echasnovski/mini.nvim",
        event = { "BufReadPost", "BufNewFile", "VeryLazy" },
        config = function()
            require('mini.pick').setup()
            require('mini.pairs').setup()
            require('mini.jump').setup()
            require('mini.jump2d').setup()
            require('mini.cursorword').setup()
            require('mini.hipatterns').setup()
            require('mini.indentscope').setup()
            require('mini.bracketed').setup({
                file = { suffix = '' },
            })
        end,
    },
    {
        "piersolenski/import.nvim",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require('import').setup()
        end,
    },
    {
        "iamcco/markdown-preview.nvim",
        ft = "markdown",
        build = function() vim.fn["mkdp#util#install"]() end,
        config = function()
            vim.g.mkdp_auto_close = 0
        end,
    },
    { "nvim-telescope/telescope.nvim", cmd = "Telescope", dependencies = { "nvim-lua/plenary.nvim" } },
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        -- Load when editing a directory, or on demand via keymaps
        lazy = true,
        config = function()
            require('oil').setup({
                default_file_explorer = false,
                columns = { "icon" },
                buf_options = { buflisted = true },
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
                delete_to_trash = false,
                skip_confirm_for_simple_edits = false,
                prompt_save_on_select_new_entry = true,
                cleanup_delay_ms = 2000,
                lsp_file_methods = {
                    enabled = true,
                    timeout_ms = 1000,
                    autosave_changes = false,
                },
                constrain_cursor = "editable",
                watch_for_changes = false,
                keymaps = {
                    ["g?"]    = { "actions.show_help", mode = "n" },
                    ["<CR>"]  = "actions.select",
                    ["<C-s>"] = { "actions.select", opts = { vertical = true } },
                    ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
                    ["<C-t>"] = { "actions.select", opts = { tab = true } },
                    ["<C-p>"] = "actions.preview",
                    ["<C-c>"] = { "actions.close", mode = "n" },
                    ["<C-l>"] = "actions.refresh",
                    ["-"]     = { "actions.parent", mode = "n" },
                    ["_"]     = { "actions.open_cwd", mode = "n" },
                    ["`"]     = { "actions.cd", mode = "n" },
                    ["~"]     = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
                    ["gs"]    = { "actions.change_sort", mode = "n" },
                    ["gx"]    = "actions.open_external",
                    ["g."]    = { "actions.toggle_hidden", mode = "n" },
                    ["g\\"]   = { "actions.toggle_trash", mode = "n" },
                },
                use_default_keymaps = true,
                view_options = {
                    show_hidden = false,
                    is_hidden_file = function(name, bufnr)
                        return name:match("^%.") ~= nil
                    end,
                    is_always_hidden = function(name, bufnr)
                        return false
                    end,
                    natural_order = "fast",
                    case_insensitive = false,
                    sort = {
                        { "type", "asc" },
                        { "name", "asc" },
                    },
                    highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
                        return nil
                    end,
                },
                extra_scp_args = {},
                git = {
                    add = function(path) return false end,
                    mv  = function(src_path, dest_path) return false end,
                    rm  = function(path) return false end,
                },
                float = {
                    padding = 2,
                    max_width = 0,
                    max_height = 0,
                    border = "rounded",
                    win_options = { winblend = 0 },
                    get_win_title = nil,
                    preview_split = "auto",
                    override = function(conf) return conf end,
                },
                preview_win = {
                    update_on_cursor_moved = true,
                    preview_method = "fast_scratch",
                    disable_preview = function(filename) return false end,
                    win_options = {},
                },
                confirmation = {
                    max_width  = 0.9,
                    min_width  = { 40, 0.4 },
                    width      = nil,
                    max_height = 0.9,
                    min_height = { 5, 0.1 },
                    height     = nil,
                    border     = "rounded",
                    win_options = { winblend = 0 },
                },
                progress = {
                    max_width  = 0.9,
                    min_width  = { 40, 0.4 },
                    width      = nil,
                    max_height = { 10, 0.9 },
                    min_height = { 5, 0.1 },
                    height     = nil,
                    border     = "rounded",
                    minimized_border = "none",
                    win_options = { winblend = 0 },
                },
                ssh         = { border = "rounded" },
                keymaps_help = { border = "rounded" },
            })
        end,
    },


}, {
    -- lazy.nvim options
    install = { colorscheme = { "oxocarbon", "habamax" } },
    checker = { enabled = false }, -- disable automatic update checks
    performance = {
        rtp = {
            -- Disable unused built-in plugins for faster startup
            disabled_plugins = {
                "gzip", "matchit", "matchparen", "netrwPlugin",
                "tarPlugin", "tohtml", "tutor", "zipPlugin",
            },
        },
    },
})

-- NVM path setup (for Mason/LSP node tools)
-- Runs after startup to avoid blocking on io.popen (macOS Gatekeeper overhead)
vim.defer_fn(function()
    local nvm_versions_dir = vim.fn.expand("$HOME/.nvm/versions/node")
    if vim.fn.isdirectory(nvm_versions_dir) == 1 then
        local versions = vim.fn.readdir(nvm_versions_dir)
        if #versions > 0 then
            local latest_version = versions[#versions]
            local nvm_node_path = nvm_versions_dir .. "/" .. latest_version .. "/bin"
            if vim.fn.isdirectory(nvm_node_path) == 1 then
                vim.env.PATH = nvm_node_path .. ":" .. vim.env.PATH
            end
        end
    end
end, 0)

-- LSP keymaps (snacks is lazy=false so this is safe here)
local snacks = require('snacks')
local gitS   = require('gitsigns')

vim.keymap.set('n', '<leader>e',  function() snacks.explorer() end,               { desc = 'Toggle file explorer' })
vim.keymap.set('n', '<leader> ',  function() snacks.picker.files() end,           { desc = 'Find files' })
vim.keymap.set('n', '<leader>/',  function() snacks.picker.grep() end,            { desc = 'Live grep' })
vim.keymap.set('n', '<leader>,',  function() snacks.picker.buffers() end,         { desc = 'Show open buffers' })
vim.keymap.set('n', '<leader>n',  function() snacks.notifier.show_history() end,  { desc = 'Open notification center' })
vim.keymap.set('n', '<leader>.',  function() snacks.scratch() end,                { desc = 'Toggle a Scratch Buffer' })
vim.keymap.set('n', '<leader>S',  function() snacks.scratch.select() end,         { desc = 'Select Scratch Buffer' })
vim.keymap.set('n', '<leader>gg', function() snacks.lazygit() end,               { desc = 'Open lazygit' })
vim.keymap.set('n', '<leader>gb', function() gitS.toggle_current_line_blame() end, { desc = 'Toggle Git Blame' })
vim.keymap.set('n', '<leader>h',  ':Pick help<cr>',                              { desc = 'Help' })
vim.keymap.set('n', 's',          '<Cmd>lua require("mini.jump").jump()<CR>',     { desc = 'Jump to character' })
vim.keymap.set('n', '<leader>j',  '<Cmd>lua require("mini.jump2d").start()<CR>',  { desc = '2D jump' })
vim.keymap.set('n', '<Esc>',      '<Cmd>nohlsearch<CR>',                         { desc = 'Clear search highlighting' })
vim.keymap.set('n', '<leader>qs', '<Cmd>SessionRestore<CR>',                     { desc = 'Restore session' })
vim.keymap.set('n', '<leader>qd', '<Cmd>SessionDelete<CR>',                      { desc = 'Delete session' })

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Focus left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Focus down window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Focus up window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Focus right window' })

-- Barbar keymaps
vim.keymap.set('n', '<S-h>',       '<Cmd>BufferPrevious<CR>',              { desc = 'Previous buffer' })
vim.keymap.set('n', '<S-l>',       '<Cmd>BufferNext<CR>',                  { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>bb',  '<Cmd>BufferPick<CR>',                  { desc = 'Pick buffer' })
vim.keymap.set('n', '<leader>bd',  '<Cmd>BufferPickDelete<CR>',            { desc = 'Pick buffer to close' })
vim.keymap.set('n', '<leader>bc',  '<Cmd>BufferClose<CR>',                 { desc = 'Close buffer' })
vim.keymap.set('n', '<leader>bh',  '<Cmd>BufferCloseBuffersLeft<CR>',      { desc = 'Close buffers left' })
vim.keymap.set('n', '<leader>bl',  '<Cmd>BufferCloseBuffersRight<CR>',     { desc = 'Close buffers right' })
vim.keymap.set('n', '<leader>bac', '<Cmd>BufferCloseAllButCurrent<CR>',    { desc = 'Close all but current' })
vim.keymap.set('n', '<leader>baC', '<Cmd>BufferCloseAllButCurrentOrPinned<CR>', { desc = 'Close all but current or pinned' })
vim.keymap.set('n', '<leader>bap', '<Cmd>BufferCloseAllButPinned<CR>',    { desc = 'Close all but pinned' })
vim.keymap.set('n', '<leader>bav', '<Cmd>BufferCloseAllButVisible<CR>',   { desc = 'Close all but visible' })
vim.keymap.set('n', '<leader>bp',  '<Cmd>BufferPin<CR>',                  { desc = 'Pin buffer' })
vim.keymap.set('n', '<leader>b1',  '<Cmd>BufferGoto 1<CR>',               { desc = 'Go to buffer 1' })
vim.keymap.set('n', '<leader>b2',  '<Cmd>BufferGoto 2<CR>',               { desc = 'Go to buffer 2' })
vim.keymap.set('n', '<leader>b3',  '<Cmd>BufferGoto 3<CR>',               { desc = 'Go to buffer 3' })
vim.keymap.set('n', '<leader>b4',  '<Cmd>BufferGoto 4<CR>',               { desc = 'Go to buffer 4' })
vim.keymap.set('n', '<leader>b5',  '<Cmd>BufferGoto 5<CR>',               { desc = 'Go to buffer 5' })
vim.keymap.set('n', '<leader>b6',  '<Cmd>BufferGoto 6<CR>',               { desc = 'Go to buffer 6' })
vim.keymap.set('n', '<leader>b7',  '<Cmd>BufferGoto 7<CR>',               { desc = 'Go to buffer 7' })
vim.keymap.set('n', '<leader>b8',  '<Cmd>BufferGoto 8<CR>',               { desc = 'Go to buffer 8' })
vim.keymap.set('n', '<leader>b9',  '<Cmd>BufferGoto 9<CR>',               { desc = 'Go to buffer 9' })
vim.keymap.set('n', '<leader>b0',  '<Cmd>BufferLast<CR>',                 { desc = 'Go to last buffer' })
vim.keymap.set('n', '<leader>bH',  '<Cmd>BufferMovePrevious<CR>',         { desc = 'Move buffer left' })
vim.keymap.set('n', '<leader>bL',  '<Cmd>BufferMoveNext<CR>',             { desc = 'Move buffer right' })
vim.keymap.set('n', '<leader>bo1', '<Cmd>BufferOrderByBufferNumber<CR>',  { desc = 'Order by number' })
vim.keymap.set('n', '<leader>bo2', '<Cmd>BufferOrderByDirectory<CR>',     { desc = 'Order by directory' })
vim.keymap.set('n', '<leader>bo3', '<Cmd>BufferOrderByLanguage<CR>',      { desc = 'Order by language' })
vim.keymap.set('n', '<leader>bo4', '<Cmd>BufferOrderByWindowNumber<CR>',  { desc = 'Order by window number' })
vim.keymap.set('n', '<A-p>m',      '<Cmd>MarkdownPreviewToggle<CR>',      { desc = 'Toggle Markdown preview' })

-- Terminal keymaps
vim.keymap.set("n", "<C-/>", function()
    snacks.terminal.toggle(nil, {
        win = { position = "bottom", height = 0.3, border = "rounded", title = " Terminal ", title_pos = "center" },
        autoclose = true,
    })
end, { desc = "Toggle Terminal" })
vim.keymap.set("n", "<C-S-/>", function()
    snacks.terminal.open(nil, {
        win = { position = "bottom", height = 0.3, border = "rounded", title = " Terminal ", title_pos = "center" },
        autoclose = true,
    })
end, { desc = "New Terminal" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("t", "<C-/>", function()
    snacks.terminal.toggle(nil, {
        win = { position = "bottom", height = 0.3, border = "rounded", title = " Terminal ", title_pos = "center" },
        autoclose = true,
    })
end, { desc = "Toggle Terminal" })

-- Reapply treesitter after session restore (focused buffer races its own FileType event)
vim.api.nvim_create_autocmd('VimEnter', {
    once = true,
    callback = function()
        vim.schedule(function()
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_loaded(buf) then
                    if vim.bo[buf].filetype == '' then
                        local ft = vim.filetype.match({ buf = buf })
                        if ft then vim.bo[buf].filetype = ft end
                    end
                    pcall(vim.treesitter.start, buf)
                end
            end
        end)
    end,
})

vim.keymap.set('n', '<leader>th', function()
    vim.cmd('filetype detect')
    local buf = vim.api.nvim_get_current_buf()
    local ft = vim.bo[buf].filetype
    local lang = vim.treesitter.language.get_lang(ft)
    if lang then
        vim.treesitter.stop(buf)
        pcall(vim.treesitter.start, buf, lang)
    else
        vim.notify('No treesitter parser for filetype: ' .. ft, vim.log.levels.WARN)
    end
end, { desc = 'Reload treesitter highlighting' })

-- LSP keymaps
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format,                            { desc = 'LSP Format buffer' })
vim.keymap.set('n', 'gd',         function() snacks.picker.lsp_definitions() end, { desc = 'Go to definition' })
vim.keymap.set('n', 'gr',         function() snacks.picker.lsp_references() end,  { desc = 'Go to references' })
vim.keymap.set('n', 'K',          vim.lsp.buf.hover,                             { desc = 'Show hover documentation' })
vim.keymap.set('n', '<leader>k',  vim.lsp.buf.signature_help,                   { desc = 'Show signature help' })
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>rn', vim.lsp.buf.rename,             { desc = 'LSP rename' })

