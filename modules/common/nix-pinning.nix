{ inputs, ... }:

{
  # Ensure nix shell nixpkgs# commands follow the flake's nixpkgs
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.registry.nixpkgs-unstable.flake = inputs.nixpkgs-unstable;

  # Ensure nix-shell import <nixpkgs> and <nixpkgs-unstable> follow the flake's
  # nixpkgs
  nix.nixPath = [
    "nixpkgs=flake:nixpkgs"
    "nixpkgs-unstable=flake:nixpkgs-unstable"
  ];
}
