local chromakeys = require("chromakeys_nvim")
local statusbar = require("statusbar")

vim.cmd('filetype plugin indent on')
vim.cmd('syntax enable')
vim.cmd.colorscheme('chromakeys')
vim.cmd('set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175')

vim.o.showmode       = false
vim.o.number         = true
vim.o.relativenumber = false
vim.o.cursorline     = true
vim.o.cursorlineopt  = 'number'
vim.o.tabstop        = 4
vim.o.expandtab      = false
vim.o.smartindent    = true
vim.o.termguicolors  = true
vim.o.ignorecase = true
vim.o.smartcase = true

vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

vim.o.signcolumn = 'yes'


local keymapOptions = { noremap=true, silent=true }

vim.keymap.set('n', '<C-s>', ":write<CR>", keymapOptions)
vim.keymap.set('n', '<C-q>', ":q!<CR>", keymapOptions)
vim.keymap.set("n", "<C-x>", "dd", keymapOptions)
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", keymapOptions)
vim.keymap.set("n", "<C-x>", "dd", keymapOptions)
vim.keymap.set("n", "<C-a>", "ggVG", keymapOptions)
-- vim.keymap.set("n", "<C-p>", ":popup PopUp<CR>", keymapOptions)
vim.keymap.set("n", "<C-p>", ":Inspect<CR>", keymapOptions)
vim.keymap.set("n", "<C-h>", ":help highlight-groups<CR>:resize<CR>", keymapOptions)
vim.keymap.set('n', '<A-]>',     "<C-W><C-W>:resize<CR>", keymapOptions)

vim.keymap.set('n', '<A-Left>',  chromakeys.previousScope)
vim.keymap.set('n', '<A-Right>', chromakeys.nextScope)
vim.keymap.set('n', '<A-r>',     chromakeys.randomizeColor)
vim.keymap.set('n', '<A-1>',     chromakeys.previousColorFunction)
vim.keymap.set('n', '<A-2>',     chromakeys.nextColorFunction)
vim.keymap.set('n', '<A-3>',     chromakeys.generateColorScheme)
vim.keymap.set('n', '<F8>',      chromakeys.generateColorScheme)
vim.keymap.set('n', '<A-g>',     chromakeys.generateColorScheme)
vim.keymap.set('n', '<A-k>',     chromakeys.previousColorScheme)
vim.keymap.set('n', '<A-l>',     chromakeys.nextColorScheme)
vim.keymap.set('n', '<F5>',      chromakeys.increaseHue)
vim.keymap.set('n', '<S-F5>',    chromakeys.decreaseHue)
vim.keymap.set('n', '<F6>',      chromakeys.increaseSaturation)
vim.keymap.set('n', '<S-F6>',    chromakeys.decreaseSaturation)
vim.keymap.set('n', '<F7>',      chromakeys.increaseLightness)
vim.keymap.set('n', '<S-F7>',    chromakeys.decreaseLightness)
vim.keymap.set('n', '<F9>',      chromakeys.increaseHueLarge)
vim.keymap.set('n', '<S-F9>',    chromakeys.decreaseHueLarge)
vim.keymap.set('n', '<F10>',     chromakeys.increaseSaturationLarge)
vim.keymap.set('n', '<S-F10>',   chromakeys.decreaseSaturationLarge)
vim.keymap.set('n', '<F11>',     chromakeys.increaseLightnessLarge)
vim.keymap.set('n', '<S-F11>',   chromakeys.decreaseLightnessLarge)
vim.keymap.set('n', '<F2>',      chromakeys.saveTheme)

vim.api.nvim_create_user_command('CkselectHighlightGroup', function(opts) chromakeys.setScope(opts.args)   end, { nargs = 1 })
vim.api.nvim_create_user_command('CkshowHighlightGroups',  function()     chromakeys.showHighlightGroups() end, {})
vim.api.nvim_create_user_command('Ckdebug',                function()     chromakeys.showInfo()            end, {})
vim.api.nvim_create_user_command('Cksavetheme',            function()     chromakeys.saveTheme()           end, {})


-- vim.treesitter.language.add('javascript', { path = "/home/main/.config/nvim/parser/javascript.so" })
-- vim.treesitter.language.register('javascript', { 'js', 'jsx' })
-- vim.treesitter.language.add('cpp', { path = "/home/main/.config/nvim/parser/cpp.so" })
-- vim.treesitter.language.register('cpp', { 'cpp' })

-- vim.o.statusline = '%<%f %l,%c%V'

-- vim.o.statusline = '%{%v:lua.StatusBar()%}'

-- require('mini.statusline').setup()

statusbar.StatusBar()
