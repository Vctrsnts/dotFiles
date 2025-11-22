--[[

FITXER SETTINGS.LUA

--]]

----------------------------------------------------------------------------------------------------
-- Neovim API Aliases
----------------------------------------------------------------------------------------------------
local cmd = vim.cmd
local exec = vim.api.nvim_exec
local fn = vim.fn
local g = vim.g
local opt = vim.opt

----------------------------------------------------------------------------------------------------
-- Configuració General
----------------------------------------------------------------------------------------------------
g.mapleader = ';'					                            -- Canviar leader a coma
opt.swapfile = false					                        -- No fe servir swapfile

----------------------------------------------------------------------------------------------------
-- Neovim UI
----------------------------------------------------------------------------------------------------
opt.number = true					                            -- Es visualitzar els numeros de les linias
opt.relativenumber = true				                      -- Es visualitzar el numero relatiu de la linia
opt.foldmethod = 'marker'				                      -- Activada folding (default 'foldmarker')
opt.splitright = true					                        -- vertical split to the right
opt.splitbelow = true					                        -- horizontal split to the bottom
opt.linebreak = true					                        -- wrap on word boundary
opt.colorcolumn = '80'					                      -- Es visualitzar la linia que marca els 80 caracters
opt.termguicolors = true 
--opt.guifont = "JetBrainsMono Nerd Font"
opt.guifont = "Fira Code"
g.neovide_cursor_vfx_mode = "railgun"

opt.list = true
opt.listchars = 'tab:▸ ,space:·,nbsp:␣,trail:•,precedes:«,extends:»'

---------------------------------------------------------------------------------------------------
-- Corrector ortografic per llenguatge
---------------------------------------------------------------------------------------------------
exec ([[
	augroup markdownSpell
		autocmd!
		autocmd FileType mardown setlocal spell Spelllang=es
		autocmd BufRead,BufNewFile *.md setlocal spell spelllang=es
	augroup END
]], false)

---------------------------------------------------------------------------------------------------
-- Tabs, indent
---------------------------------------------------------------------------------------------------
opt.expandtab = true					                        -- use spaces instead of tabs
opt.shiftwidth = 2					                          -- shift 2 spaces when tab
opt.tabstop = 2						                            -- 1 tab == 2 spaces
opt.smartindent = true					                      -- autoindent new lines

---------------------------------------------------------------------------------------------------
-- Activació dels templates
---------------------------------------------------------------------------------------------------
exec([[
  augroup templates
      au!
      let g:template_name = 'Victor Santos'
      autocmd BufNewFile *.* silent! execute '0r $HOME/.config/nvim/templates/'.expand("<afile>:e").'.tpl'
      autocmd BufNewFile * %s/{{DATE}}/\=strftime('%F')/ge
      autocmd BufNewFile * %s/{{NAME}}/\=template_name/ge
      autocmd BufNewFile * %s/{{EVAL\s*\([^}]*\)}}/\=eval(submatch(1))/ge
      autocmd BufNewFile * %s/{{FILENAME}}/\=expand('%:t')/ge
  augroup END
]], false)

---------------------------------------------------------------------------------------------------
-- Memory, CPU
---------------------------------------------------------------------------------------------------
opt.hidden = true                                     -- enable background buffers
--opt.history = 100                                   -- remember n lines in history
opt.lazyredraw = true                                 -- faster scrolling
opt.synmaxcol = 1000                                  -- max column for syntax highlight

---------------------------------------------------------------------------------------------------
-- Configuració Text mardown
---------------------------------------------------------------------------------------------------
cmd [[autocmd FileType markdown let g:indentLine_enabled=0]]
