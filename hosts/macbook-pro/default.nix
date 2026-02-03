{ nixpkgs, nixpkgs-unstable, nix-darwin, home-manager, overlays, sops-nix
, neovim-config, ... }:

let system = "aarch64-darwin";
in nix-darwin.lib.darwinSystem {
  system = system;
  pkgs = import nixpkgs {
    system = system;
    config.allowUnfree = true;
    overlays = overlays;
  };
  specialArgs = {
    pkgs-unstable = import nixpkgs-unstable {
      system = system;
      config.allowUnfree = true;
      overlays = overlays;
    };
    system = system;
    nixpkgs = nixpkgs;
    nixpkgs-unstable = nixpkgs-unstable;
    sops-nix = sops-nix;
    neovim-config = neovim-config;
  };

  modules = [
    ./configuration.nix
    ./home-manager.nix
    home-manager.darwinModules.home-manager
  ];
}
