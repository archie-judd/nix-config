{ inputs, overlays }:

let
  system = "aarch64-darwin";
  pkgs = import inputs.nixpkgs {
    system = system;
    config.allowUnfree = true;
    overlays = overlays;
  };
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = system;
    config.allowUnfree = true;
    overlays = overlays;
  };
in inputs.nix-darwin.lib.darwinSystem {
  system = system;
  pkgs = pkgs;
  specialArgs = {
    pkgs-unstable = pkgs-unstable;
    inputs = inputs;
  };

  modules = [
    ./configuration.nix
    ./home-manager.nix
    inputs.home-manager.darwinModules.home-manager
  ];
}
