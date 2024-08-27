{ pkgs, neovim-config, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "archie";
  home.homeDirectory = "/home/archie";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # ADDITIONS:

  home.sessionVariables = { EDITOR = "nvim"; };

  imports = [
    ../modules/alacritty
    ../modules/bash
    ../modules/tmux
    ../modules/direnv.nix
    ../modules/firefox.nix
    ../modules/fzf.nix
    ../modules/gnome.nix
    ../modules/starship.nix
    ../modules/git.nix
    ../modules/xdg.nix
  ];

  home.packages = [
    pkgs.bashInteractive
    pkgs.ripgrep
    pkgs.fd
    pkgs.eza
    pkgs._1password # 1password-8.10.36 on unstable was broken
    pkgs._1password-gui # 1password-8.10.36 on unstable was broken
    pkgs.awscli2 # awscli2-2.17.18 failed to build on unstable
    pkgs.solaar
    pkgs.nix-direnv
    pkgs.slack
    pkgs.spotify
    neovim-config.packages.${pkgs.system}.default
  ];
}
