{ nixpkgs, nixpkgs-unstable, home-manager, bbc-to-spotify, ... }:
let system = "aarch64-linux";
in home-manager.lib.homeManagerConfiguration {
  pkgs = import nixpkgs {
    system = system;
    config.allowUnfree = true;
  };
  modules = [ ../../profiles/personal-rpi.nix ];
  extraSpecialArgs = {
    pkgs-unstable = import nixpkgs-unstable {
      system = system;
      config.allowUnfree = true;
    };
    nixpkgs = nixpkgs;
    bbc-to-spotify = bbc-to-spotify;
  };
}
