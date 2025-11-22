--[[

  FITXER PACKER.LUA
  S'ENCARREGA DE TOTA LA CONFIGURACIÓ / CARREGA DE PLUGINS

  Plugin manager: packer.nvim
  https://github.com/wbthomason/packer.nvim

  For information about installed plugins see the README
  neovim-lua/README.md
  https://github.com/brainfucksec/neovim-lua#readme
----]]

local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end
return require('packer').startup(function(use)
  -- My plugins here
  -- use 'foo1/bar1.nvim'
  -- use 'foo2/bar2.nvim'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  use 'wbthomason/packer.nvim'
  
  -------------------------------------------------------------------------------------------------
  -- colorschemes
  -------------------------------------------------------------------------------------------------
  use 'Shatur/neovim-ayu'

  -------------------------------------------------------------------------------------------------
  -- Activem Icones
  -------------------------------------------------------------------------------------------------
  use 'kyazdani42/nvim-web-devicons'
  use 'adelarsq/vim-devicons-emoji'

  -------------------------------------------------------------------------------------------------
  -- Activem Explorer / Navegador de directoris
  -------------------------------------------------------------------------------------------------
  use {
      'nvim-neo-tree/neo-tree.nvim',
      branch = "v2.x",
      requires = {
        "nvim-lua/plenary.nvim",
        "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim"
      }
  }

  -------------------------------------------------------------------------------------------------
  -- Activem Status Line
  -------------------------------------------------------------------------------------------------
  use ('Iron-E/nvim-highlite')
  use {
     'feline-nvim/feline.nvim',
      requires = {
  --      'gitsigns.nvim',
        'nvim-web-devicons'
    },
  }

  -------------------------------------------------------------------------------------------------
  -- Activem el AutoSave
  -------------------------------------------------------------------------------------------------
  use "Pocco81/auto-save.nvim"

  -------------------------------------------------------------------------------------------------
  -- Activem autocomplete i snipets
  -------------------------------------------------------------------------------------------------
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'L3MON4D3/LuaSnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'f3fora/cmp-spell',
      'saadparwaiz1/cmp_luasnip',
    },
  }
  use 'rafamadriz/friendly-snippets'
  use {'onsails/lspkind-nvim'}

  -------------------------------------------------------------------------------------------------
  -- Final del fitxer de configuració de plugins
  -------------------------------------------------------------------------------------------------
  if packer_bootstrap then
    require('packer').sync()
  end
end)
