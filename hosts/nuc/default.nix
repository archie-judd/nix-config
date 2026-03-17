{ nixpkgs, nixpkgs-unstable, home-manager, overlays, neovim-config, ... }:

let system = "x86_64-linux";
in home-manager.lib.homeManagerConfiguration {
  pkgs = import nixpkgs {
    system = system;
    config.allowUnfree = true;
    overlays = overlays;
  };
  modules = [ ./home.nix ];
  extraSpecialArgs = {
    nixpkgs = nixpkgs;
    nixpkgs-unstable = nixpkgs-unstable;
    pkgs-unstable = import nixpkgs-unstable {
      system = system;
      config.allowUnfree = true;
      overlays = overlays;
    };
    neovim-config = neovim-config;
  };
}
