{ pkgs, bbc-to-spotify, neovim-config, nixpkgs, ... }:

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

  home.sessionVariables = { EDITOR = "nvim"; };

  imports = [
    ../modules/alacritty
    ../modules/bash
    ../modules/tmux
    ../modules/karabiner
    ../modules/direnv.nix
    ../modules/fzf.nix
    ../modules/starship.nix
    ../modules/git
  ];

  home.packages = [
    pkgs.bashInteractive
    pkgs.ripgrep
    pkgs.fd
    pkgs.eza
    pkgs.nix-direnv
    pkgs.transmission_4
    bbc-to-spotify.packages.${pkgs.system}.default
    neovim-config.packages.${pkgs.system}.default
    neovim-config.packages.${pkgs.system}.nvim-rtp
  ];

  # Point system nixpkgs(used by nix run & nix shell) to the same nixpkgs as my flake
  nix.registry.nixpkgs.flake = nixpkgs;

}
