{ nixpkgs, nixpkgs-unstable, home-manager, sops-nix, neovim-config
, bbc-to-spotify, nix-darwin, ... }:

let
  system = "aarch64-darwin";
in
nix-darwin.lib.darwinSystem {
  system = system;
  specialArgs = {
    pkgs-unstable = import nixpkgs-unstable {
      system = system;
      config.allowUnfree = true;
    };
    system = system;
    nixpkgs = nixpkgs;
    nixpkgs-unstable = nixpkgs-unstable;
    sops-nix = sops-nix;
    neovim-config = neovim-config;
    bbc-to-spotify = bbc-to-spotify;
  };

  modules = [
    ../../../overlays
    ./configuration.nix
    home-manager.darwinModules.home-manager
    ./home-manager.nix
  ];
}
