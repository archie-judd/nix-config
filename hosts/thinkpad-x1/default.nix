{ nixpkgs, nixpkgs-unstable, home-manager, sops-nix, neovim-config
, kolide-launcher, ... }:

let
  system = "x86_64-linux";
in
nixpkgs.lib.nixosSystem {
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
  };

  modules = [
    ../../overlays.nix
    ./configuration.nix
    kolide-launcher.nixosModules.kolide-launcher
    home-manager.nixosModules.home-manager
    sops-nix.nixosModules.sops
    ./home-manager.nix
  ];
}
