{ pkgs, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "archiejudd";
  home.homeDirectory = "/home/archiejudd";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # ADDITIONS:

  home.sessionVariables = { EDITOR = "nvim"; };

  imports = [
    ../../modules/home-manager/alacritty
    ../../modules/home-manager/tmux
    ../../modules/home-manager/git
    ../../modules/home-manager/bash.nix
    ../../modules/home-manager/direnv.nix
    ../../modules/home-manager/fzf.nix
    ../../modules/home-manager/starship.nix
  ];

  home.packages = [
    pkgs.nodejs # stop copilot picking up the system node and complaining it is out-of-date
    pkgs.bashInteractive
    pkgs.ripgrep
    pkgs.fd
    pkgs.eza
    pkgs.awscli2
    pkgs.nix-direnv
    inputs.neovim-config.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # Point system nixPath(used by import <nixpkgs> {}) to the same nixpkgs as my flake
  home.sessionVariables = {
    NIX_PATH = "nixpkgs=flake:nixpkgs:nixpkgs-unstable=flake:nixpkgs-unstable";
  };

  # Point system nixpkgs(used by nix run & nix shell) to the same nixpkgs as my flake
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.registry.nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
}
