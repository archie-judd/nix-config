{ inputs, overlays }:

let
  system = "x86_64-linux";
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
in inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = pkgs;
  modules = [ ./home.nix ];
  extraSpecialArgs = {
    pkgs-unstable = pkgs-unstable;
    inputs = inputs;
  };
}
