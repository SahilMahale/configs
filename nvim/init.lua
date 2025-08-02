vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4
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
vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<Esc>:w<cr>', { desc = 'Save and gotonormal mode' })
vim.keymap.set('n', '<leader>o', ':update<cr> :source<cr>', { desc = 'Update and source file' })
-- Copy to system clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'Copy to system clipboard' })
vim.keymap.set('n', '<leader>Y', '"+Y', { desc = 'Copy line to system clipboard' })

-- Paste from system clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>P', '"+P', { desc = 'Paste before from system clipboard' })
vim.keymap.set('n', '<leader>tW', function()
	vim.opt.wrap = not vim.opt.wrap:get()
	local status = vim.opt.wrap:get() and "ON" or "OFF"
	vim.notify("Text wrap: " .. status, vim.log.levels.INFO)
end, { desc = 'Toggle text wrap' })


-- Install packages
vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/EdenEast/nightfox.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/folke/snacks.nvim" },
	{ src = "https://github.com/echasnovski/mini.nvim" },
	{ src = "https://github.com/folke/which-key.nvim" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/romgrk/barbar.nvim" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/rmagatti/auto-session" },
	{ src = "https://github.com/numToStr/Comment.nvim" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/folke/noice.nvim" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = "https://github.com/saghen/blink.cmp",                         build = "cargo build --release" },
})

require('mini.pick').setup()
require('mini.pairs').setup()
require('mini.jump').setup()       -- Quick character jumping
require('mini.jump2d').setup()     -- 2D jumping within visible lines
require('mini.cursorword').setup() -- Highlight word under cursor
require('mini.hipatterns').setup() -- Pattern highlighting
require('Comment').setup()

-- Blink.cmp setup
require('blink.cmp').setup({
	keymap = {
		preset = 'default',
		['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
		['<C-e>'] = { 'hide' },
		['<C-y>'] = { 'select_and_accept' },

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
		bottom_search = true, -- use a classic bottom cmdline for search
		command_palette = true, -- position the cmdline and popupmenu together
		long_message_to_split = true, -- long messages will be sent to a split
		inc_rename = false, -- enables an input dialog for inc-rename.nvim
		lsp_doc_border = false, -- add a border to hover docs and signature help
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

	dashboard = {
		enabled = true,
		animate = true,
		preset = {
			header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
			keys = {
				{ icon = " ", key = "f", desc = "Find File",    action = function() snacks.picker.files() end },
				{ icon = " ", key = "n", desc = "New File",     action = ":ene | startinsert" },
				{ icon = " ", key = "r", desc = "Recent Files", action = function() snacks.picker.recent() end },
				{ icon = " ", key = "g", desc = "Find Text",    action = function() snacks.picker.grep() end },
				{ icon = " ", key = "c", desc = "Config",       action = ":e $MYVIMRC" },
				{ icon = " ", key = "q", desc = "Quit",         action = ":qa" },
			},
			-- Remove sections that depend on lazy.nvim
		},
		sections = {
			{ section = "header" },
			{ section = "keys",  gap = 1, padding = 1 },
			-- Don't include startup section which tries to use lazy stats
		},
	},
	explorer = { enabled = true },
	picker = {
		enabled = true,
		sources = {
			explorer = {
				layout = {
					layout = {
						position = "right",
						width = 22
					}
				}
			}
		}
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
				step = 10, -- Shorter steps for performance
				total = 150, -- Shorter total duration
			},
			easing = "linear", -- Linear is most performant
		},
		spamming = 5, -- Lower spamming threshold
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
-- keymaps for plugins
vim.keymap.set('n', '<leader>e', function() snacks.explorer() end, { desc = 'Toggle file explorer' })
vim.keymap.set('n', '<leader> ', function() snacks.picker.files() end, { desc = 'Find files' })
vim.keymap.set('n', '<leader>/', function() snacks.picker.grep() end, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>,', function() snacks.picker.buffers() end, { desc = 'Show open buffers' })
vim.keymap.set('n', '<leader>n', function() snacks.notifier.show_history() end, { desc = 'Open notification center' })
vim.keymap.set('n', '<leader>.', function() snacks.scratch() end, { desc = 'Toggle a Scratch Buffer' })
vim.keymap.set('n', '<leader>S', function() snacks.scratch.select() end, { desc = 'Toggle a Scratch Buffer' })
vim.keymap.set('n', '<leader>gg', function() snacks.lazygit() end, { desc = 'Open lazygit' })
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
vim.keymap.set('n', '<leader>bc', '<Cmd>BufferClose<CR>', { desc = 'Close buffer' })
vim.keymap.set('n', '<leader>bp', '<Cmd>BufferPin<CR>', { desc = 'Pin buffer' })

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

setup_nvm_path()

require("mason").setup({
	PATH = "prepend", -- Ensure mason's bin is in PATH
	-- Add nvm node path
	install_root_dir = vim.fn.stdpath("data") .. "/mason",
})
require("mason-lspconfig").setup({
	handlers = {
		function(server_name)
			require('lspconfig')[server_name].setup({
				capabilities = require('blink.cmp').get_lsp_capabilities()
			})
		end,
	}
})
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
})
-- Set Luajit so it doesn't show warnings for vim globals
vim.lsp.config('lua_ls', {
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using
				-- (most likely LuaJIT in the case of Neovim)
				version = 'LuaJIT',
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = {
					'vim',
					'require'
				},
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, { desc = 'LSP Format buffer' })
-- inbuilt nvim autocomplete
--[[ vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})
vim.cmd("set completeopt+=noselect") ]]
-- Color theme
vim.cmd("colorscheme carbonfox")
