{ nixpkgs, nixpkgs-unstable, nix-darwin, home-manager, overlays, sops-nix
, neovim-config, claude-code-nix, ... }:

let
  system = "aarch64-darwin";
  pkgs = import nixpkgs {
    system = system;
    config.allowUnfree = true;
    overlays = overlays;
  };
  pkgs-unstable = import nixpkgs-unstable {
    system = system;
    config.allowUnfree = true;
    overlays = overlays;
  };
in nix-darwin.lib.darwinSystem {
  system = system;
  pkgs = pkgs;
  specialArgs = {
    nixpkgs = nixpkgs;
    pkgs-unstable = pkgs-unstable;
    sops-nix = sops-nix;
    neovim-config = neovim-config;
    claude-code-nix = claude-code-nix;
  };

  modules = [
    ./configuration.nix
    ./home-manager.nix
    home-manager.darwinModules.home-manager
  ];
}
