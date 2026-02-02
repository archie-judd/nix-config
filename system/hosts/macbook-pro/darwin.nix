{ nixpkgs, nixpkgs-unstable, home-manager, ... }:
let system = "x86_64-darwin";
in nix-darwin.lib.darwinSystem {
  system = system;
  specialArgs = {
    system = system;
    nixpkgs = nixpkgs;
    pkgs-unstable = import nixpkgs-unstable {
      system = system;
      config.allowUnfree = true;
    };
  };
  modules = [
    ./overlays
    ./system/hosts/macbook-pro/configuration.nix
    home-manager.darwinModules.home-manager

  ];
}
