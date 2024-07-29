{ pkgs, ... }:

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
    ../modules/nvim
    ../modules/tmux
    ../modules/direnv.nix
    ../modules/fzf.nix
    ../modules/starship.nix
    ../modules/git.nix
  ];

  home.packages = [
    pkgs.ripgrep
    pkgs.fd
    pkgs.eza
    pkgs._1password
    pkgs._1password-gui
    pkgs.nix-direnv
    pkgs.transmission_3
    pkgs.rectangle
  ];
}
