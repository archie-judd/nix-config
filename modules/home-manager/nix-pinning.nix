{ inputs, ... }:

{
  # Point system nixpkgs(used by nix run & nix shell) to the same nixpkgs as my flake
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.registry.nixpkgs-unstable.flake = inputs.nixpkgs-unstable;

  # Point system nixPath(used by import <nixpkgs> {}) to the same nixpkgs as my flake
  home.sessionVariables = {
    NIX_PATH = "nixpkgs=flake:nixpkgs:nixpkgs-unstable=flake:nixpkgs-unstable";
  };
}
