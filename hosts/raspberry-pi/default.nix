{ inputs, overlays }:

let
  system = "aarch64-linux";
  allowUnfreePredicate =
    pkg: builtins.elem (inputs.nixpkgs.lib.getName pkg) [ ];
  pkgs = import inputs.nixpkgs {
    system = system;
    overlays = overlays;
    config.allowUnfreePredicate = allowUnfreePredicate;
  };
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = system;
    overlays = overlays;
    config.allowUnfreePredicate = allowUnfreePredicate;
  };
in
inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = pkgs;
  modules = [ ./home.nix ];
  extraSpecialArgs = {
    pkgs-unstable = pkgs-unstable;
    inputs = inputs;
  };
}
