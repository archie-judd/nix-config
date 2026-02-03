{ nixpkgs, nixpkgs-unstable, home-manager, overlays, sops-nix, neovim-config
, kolide-launcher, ... }:

let system = "x86_64-linux";
in nixpkgs.lib.nixosSystem {
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
    home-manager.nixosModules.home-manager
    sops-nix.nixosModules.sops
    kolide-launcher.nixosModules.kolide-launcher
  ];
}
