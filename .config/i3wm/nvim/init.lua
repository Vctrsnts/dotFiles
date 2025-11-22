--[[
  ██╗███╗   ██╗██╗████████╗██╗     ██╗   ██╗ █████╗
  ██║████╗  ██║██║╚══██╔══╝██║     ██║   ██║██╔══██╗
  ██║██╔██╗ ██║██║   ██║   ██║     ██║   ██║███████║
  ██║██║╚██╗██║██║   ██║   ██║     ██║   ██║██╔══██║
  ██║██║ ╚████║██║   ██║██╗███████╗╚██████╔╝██║  ██║
  ╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝
Neovim init file
Version: 0.8.1 - 2022/11/14
Maintainer: Vctrsnts
Website: https://vctrsnts.github.io
Referencia: https://github.com/brainfucksec/neovim-lua
--]]

----------------------------------------------------------------------------------------------------
-- Import Lua Modules
----------------------------------------------------------------------------------------------------
require('settings')                                 -- Fitxer dels Settings
require('keymaps')			            -- Fitxer de la configuració del teclat

----------------------------------------------------------------------------------------------------
-- Comença la carrega de plugins
----------------------------------------------------------------------------------------------------
require('plugins/packer')		            -- Gestor de Plugins
require('plugins/autosave')                         -- Plugin per a realitzar el AutoSave
require('plugins/ayu')			            -- Color Theme
require('plugins/neo-tree')                         -- filebrowser
require('plugins/feline')                           -- statusline
require('plugins/luasnip')                          -- snippets
require('plugins/nvim-cmp')                         -- autocomplete
