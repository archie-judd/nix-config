{ pkgs, neovim-config, nixpkgs, ... }:

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
  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # ADDITIONS:

  home.sessionVariables = { EDITOR = "nvim"; };

  imports = [
    ../modules/alacritty
    ../modules/bash
    ../modules/direnv.nix
    ../modules/fzf.nix
    ../modules/starship.nix
    ../modules/git.nix
  ];

  home.packages = [
    pkgs.bashInteractive
    pkgs.chromium
    pkgs.chromedriver
    pkgs.ripgrep
    pkgs.fd
    pkgs.eza
    pkgs.nix-direnv
    neovim-config.packages.${pkgs.system}.default
  ];

  # Point system nixpkgs(used by nix run & nix shell) to the same nixpkgs as my flake
  nix.registry.nixpkgs.flake = nixpkgs;
}
