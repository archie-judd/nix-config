{ nixpkgs, nixpkgs-unstable, home-manager, overlays, neovim-config
, bbc-to-spotify, ... }:

let
  system = "aarch64-linux";
  pkgs-unstable = import nixpkgs-unstable {
    system = system;
    config.allowUnfree = true;
    overlays = overlays;
  };
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
    pkgs-unstable = pkgs-unstable;
    neovim-config = neovim-config;
    bbc-to-spotify = bbc-to-spotify;
  };
}
