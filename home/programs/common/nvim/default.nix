{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;

    package = pkgs.neovim-unwrapped.overrideAttrs (_: {
      src = pkgs.fetchFromGitHub {
        owner = "neovim";
        repo = "neovim";
        rev = "344906a08f0972108eb912c87af32b275ecf318e";
        hash = "sha256-h5lyhF+FMLrz1RHDZC6oRKG3RR7v26Mas085ga+9EYo=";
      };
    });

    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withPython3 = true;
    withNodeJs = true;

    plugins = with pkgs.vimPlugins; [
      nvim-treesitter
      nvim-treesitter-parsers.python
      nvim-treesitter-parsers.markdown
      nvim-treesitter-parsers.javascript
      nvim-treesitter-parsers.typescript
      nvim-treesitter-parsers.lua
      nvim-treesitter-parsers.vim
      nvim-treesitter-parsers.vimdoc
      nvim-treesitter-parsers.json
      nvim-treesitter-parsers.html
      nvim-treesitter-parsers.nix
      nvim-treesitter-parsers.yaml
      nvim-treesitter-parsers.bash
      oil-nvim
      catppuccin-nvim
      telescope-nvim
      telescope-live-grep-args-nvim
      nvim-lspconfig
      neodev-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp-path
      cmp-dap
      cmp-cmdline
      vim-markdown-toc
      markdown-preview-nvim
      conform-nvim
      nvim-dap
      diffview-nvim
      nvim-web-devicons
      eyeliner-nvim
      vim-fugitive
      gitsigns-nvim
      lualine-nvim
      mini-nvim
      neotest
      neotest-python
      tmux-nvim
    ];

    extraPackages = with pkgs; [
      ripgrep
      fd
      nodePackages.bash-language-server
      nodePackages.typescript-language-server
      lua-language-server
      marksman
      ruff
      pyright
      nixd
      nodePackages.eslint
      prettierd
      shfmt
      stylua
      nixfmt-classic
      black
      isort
    ];

    extraPython3Packages = pyPkgs: with pyPkgs; [ debugpy ];
  };

  home.file."./.config/nvim/" = {
    source = ./nvim;
    recursive = true;
  };
}
