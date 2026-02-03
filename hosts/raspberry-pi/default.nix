{ nixpkgs, nixpkgs-unstable, home-manager, overlays, bbc-to-spotify, ... }:

let system = "aarch64-linux";
in home-manager.lib.homeManagerConfiguration {
  pkgs = import nixpkgs {
    system = system;
    config.allowUnfree = true;
    overlays = overlays;
  };
  modules = [ ./home.nix ];
  extraSpecialArgs = {
    pkgs-unstable = import nixpkgs-unstable {
      system = system;
      config.allowUnfree = true;
      overlays = overlays;
    };
    nixpkgs = nixpkgs;
    bbc-to-spotify = bbc-to-spotify;
  };
}
