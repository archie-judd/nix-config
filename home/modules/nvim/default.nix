{ pkgs, pkgs-stable, ... }:

{
  programs.neovim = {
    enable = true;

    package = pkgs.neovim-unwrapped;

    defaultEditor = true;
    withPython3 = true;
    withNodeJs = true;

    plugins = [
      pkgs.vimPlugins.nvim-treesitter
      pkgs.vimPlugins.nvim-treesitter-parsers.python
      pkgs.vimPlugins.nvim-treesitter-parsers.markdown
      pkgs.vimPlugins.nvim-treesitter-parsers.javascript
      pkgs.vimPlugins.nvim-treesitter-parsers.typescript
      pkgs.vimPlugins.nvim-treesitter-parsers.lua
      pkgs.vimPlugins.nvim-treesitter-parsers.vim
      pkgs.vimPlugins.nvim-treesitter-parsers.vimdoc
      pkgs.vimPlugins.nvim-treesitter-parsers.json
      pkgs.vimPlugins.nvim-treesitter-parsers.html
      pkgs.vimPlugins.nvim-treesitter-parsers.nix
      pkgs.vimPlugins.nvim-treesitter-parsers.yaml
      pkgs.vimPlugins.nvim-treesitter-parsers.bash
      pkgs.vimPlugins.nvim-treesitter-parsers.haskell
      pkgs.vimPlugins.nvim-treesitter-parsers.c
      pkgs-stable.vimPlugins.nvim-treesitter-parsers.sql
      pkgs.vimPlugins.nvim-treesitter-textobjects
      pkgs.vimPlugins.oil-nvim
      pkgs.vimPlugins.catppuccin-nvim
      pkgs.vimPlugins.telescope-nvim
      pkgs.vimPlugins.telescope-live-grep-args-nvim
      pkgs.vimPlugins.nvim-lspconfig
      pkgs.vimPlugins.neodev-nvim
      pkgs.vimPlugins.nvim-cmp
      pkgs.vimPlugins.cmp-nvim-lsp
      pkgs.vimPlugins.cmp-path
      pkgs.vimPlugins.cmp-dap
      pkgs.vimPlugins.cmp-cmdline
      pkgs.vimPlugins.lsp_signature-nvim
      pkgs.vimPlugins.vim-markdown-toc
      pkgs.vimPlugins.markdown-preview-nvim
      pkgs.vimPlugins.conform-nvim
      pkgs.vimPlugins.nvim-dap
      pkgs.vimPlugins.diffview-nvim
      pkgs.vimPlugins.nvim-web-devicons
      pkgs.vimPlugins.eyeliner-nvim
      pkgs.vimPlugins.vim-fugitive
      pkgs.vimPlugins.gitsigns-nvim
      pkgs.vimPlugins.lualine-nvim
      pkgs.vimPlugins.mini-nvim
      pkgs.vimPlugins.neotest
      pkgs.vimPlugins.neotest-python
      pkgs.vimPlugins.tmux-nvim
    ];

    extraPackages = [
      pkgs.gcc
      pkgs.ripgrep
      pkgs.fd
      pkgs.bash-language-server
      pkgs.nodePackages.typescript-language-server
      pkgs.haskell-language-server
      pkgs.lua-language-server
      pkgs.marksman
      pkgs.ruff
      pkgs.pyright
      pkgs.nixd
      pkgs.nodePackages.vscode-langservers-extracted
      pkgs.nodePackages.eslint
      pkgs.prettierd
      pkgs.shfmt
      pkgs.stylua
      pkgs.sqls
      pkgs.nixfmt-classic
      pkgs.black
      pkgs.isort
      pkgs.ormolu
      pkgs.vscode-js-debug
    ];

    extraPython3Packages = pyPkgs: [ pyPkgs.debugpy ];
  };

  home.file."./.config/nvim/" = {
    source = ./nvim;
    recursive = true;
  };
}
