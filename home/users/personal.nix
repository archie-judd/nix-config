{ pkgs, pkgs-stable, bbc-to-spotify, neovim-config, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "archie";
  home.homeDirectory = "/Users/archie";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # ADDITIONS:

  imports = [
    ../modules/alacritty
    ../modules/bash
    ../modules/tmux
    ../modules/direnv.nix
    ../modules/fzf.nix
    ../modules/starship.nix
    ../modules/git.nix
  ];

  home.packages = [
    pkgs.bashInteractive
    pkgs.ripgrep
    pkgs.fd
    pkgs.eza
    pkgs-stable._1password # 1password-8.10.36 on unstable was broken
    pkgs-stable._1password-gui # 1password-8.10.36 on unstable was broken
    pkgs.nix-direnv
    pkgs.transmission_4
    pkgs.rectangle
    pkgs.spotify
    pkgs.vlc-bin-universal
    pkgs.maccy # clipboard manager
    bbc-to-spotify.packages.${pkgs.system}.default
    neovim-config.packages.${pkgs.system}.default
  ];
}
