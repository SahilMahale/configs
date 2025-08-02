# Mini.nvim Plugins Reference

This document lists all the available mini.nvim plugins and their purposes. You can enable any of these by adding `require('mini.PLUGIN_NAME').setup()` to your config.

## Currently Enabled
- `mini.pick` - File picker and fuzzy finder
- `mini.pairs` - Auto-completion of bracket pairs
- `mini.icons` - Icon provider for file types

## Available Mini.nvim Plugins

### Core Functionality
- **`mini.ai`** - Extend and create `a`/`i` textobjects (like `da"`, `ci(`)
- **`mini.align`** - Align text interactively
- **`mini.animate`** - Animate common Neovim actions (scrolling, cursor movement)
- **`mini.base16`** - Base16 colorscheme creation
- **`mini.basics`** - Common configuration presets for Neovim
- **`mini.bracketed`** - Go forward/backward with square brackets

### Buffer and File Management
- **`mini.bufremove`** - Remove buffers without losing window layout
- **`mini.files`** - Navigate and manipulate file system
- **`mini.pick`** - ✅ Pick anything (files, buffers, etc.) with fuzzy matching
- **`mini.starter`** - Start screen showing recent files and projects
- **`mini.sessions`** - Session management

### Text Editing
- **`mini.clue`** - Show next key clues
- **`mini.comment`** - Comment/uncomment code
- **`mini.completion`** - Autocompletion
- **`mini.cursorword`** - Highlight word under cursor
- **`mini.diff`** - Work with diff hunks
- **`mini.extra`** - Extra functionality for other modules
- **`mini.fuzzy`** - Fuzzy matching algorithm
- **`mini.hipatterns`** - Highlight patterns in text
- **`mini.indentscope`** - Visualize and work with indent scope
- **`mini.jump`** - Jump to any location specified by two characters
- **`mini.jump2d`** - Jump within visible lines via iterative filtering
- **`mini.move`** - Move any selection in any direction
- **`mini.operators`** - Text operators (evaluate, exchange, multiply, replace, sort)
- **`mini.pairs`** - ✅ Autopairs for brackets, quotes, etc.
- **`mini.splitjoin`** - Split and join arguments
- **`mini.surround`** - Add, delete, replace surroundings (like `ys`, `ds`, `cs` in vim-surround)
- **`mini.trailspace`** - Highlight and remove trailing whitespace

### Visual and UI
- **`mini.colors`** - Tweak and save any color scheme
- **`mini.hues`** - Generate configurable color scheme
- **`mini.icons`** - ✅ Icon provider with customizable icons
- **`mini.map`** - Window with buffer text overview
- **`mini.notify`** - Show notifications
- **`mini.statusline`** - Minimal and fast statusline
- **`mini.tabline`** - Minimal tabline showing listed buffers

### Git Integration
- **`mini.git`** - Git integration
- **`mini.diff`** - Work with diff hungs in current buffer

### Testing and Development
- **`mini.test`** - Test Neovim plugins
- **`mini.doc`** - Generate documentation
- **`mini.deps`** - Plugin manager

### Utility
- **`mini.misc`** - Miscellaneous functions
- **`mini.visits`** - Track and reuse file system visits

## Usage Examples

### Enable a plugin:
```lua
require('mini.PLUGIN_NAME').setup()
```

### Enable with custom config:
```lua
require('mini.surround').setup({
  mappings = {
    add = 'sa',
    delete = 'sd',
    find = 'sf',
    find_left = 'sF',
    highlight = 'sh',
    replace = 'sr',
    update_n_lines = 'sn',
  },
})
```

## Recommended Additions for Better Search

For better in-buffer search, consider enabling:

1. **`mini.jump`** - Quick character-based jumping
2. **`mini.jump2d`** - Visual line jumping
3. **`mini.cursorword`** - Highlight current word occurrences
4. **`mini.hipatterns`** - Highlight custom patterns

## Keymaps to Add

After enabling jump plugins, you might want these keymaps:
```lua
-- For mini.jump
vim.keymap.set('n', 's', function() require('mini.jump').jump() end, { desc = 'Jump to character' })

-- For mini.jump2d  
vim.keymap.set('n', '<leader>j', function() require('mini.jump2d').start() end, { desc = '2D jump' })
```