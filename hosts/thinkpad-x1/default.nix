{ nixpkgs, nixpkgs-unstable, home-manager, overlays, sops-nix, neovim-config
, claude-code-nix, kolide-launcher, ... }:

let
  system = "x86_64-linux";
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
in nixpkgs.lib.nixosSystem {
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
    home-manager.nixosModules.home-manager
    sops-nix.nixosModules.sops
    kolide-launcher.nixosModules.kolide-launcher
  ];
}
