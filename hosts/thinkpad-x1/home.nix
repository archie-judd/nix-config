{ pkgs, pkgs-unstable, neovim-config, nixpkgs, ... }:

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
    ../../modules/home-manager/alacritty
    ../../modules/home-manager/tmux
    ../../modules/home-manager/git
    ../../modules/home-manager/sops
    ../../modules/home-manager/agents/claude-code
    ../../modules/home-manager/agents/copilot
    ../../modules/home-manager/bash.nix
    ../../modules/home-manager/direnv.nix
    ../../modules/home-manager/firefox.nix
    ../../modules/home-manager/fzf.nix
    ../../modules/home-manager/gnome.nix
    ../../modules/home-manager/starship.nix
    ../../modules/home-manager/xdg.nix
    ../../modules/home-manager/ssl.nix
  ];

  home.packages = [
    pkgs.bashInteractive
    pkgs.ripgrep
    pkgs.jq
    pkgs.fd
    pkgs.eza
    pkgs._1password-cli
    pkgs._1password-gui
    pkgs.awscli2
    pkgs.solaar
    pkgs.nix-direnv
    pkgs.slack
    pkgs.spotify
    pkgs.chromium
    pkgs.libreoffice
    neovim-config.packages.${pkgs.stdenv.hostPlatform.system}.default
    neovim-config.packages.${pkgs.stdenv.hostPlatform.system}.nvim-rtp
  ];

  # Fixes firefox right-click cursor offset
  gtk.enable = true;

  # Point system nixpkgs(used by nix run & nix shell) to the same nixpkgs as my flake
  nix.registry.nixpkgs.flake = nixpkgs;
}
