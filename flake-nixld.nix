{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-python.url = "github:cachix/nixpkgs-python";
  };
  outputs = { self, nixpkgs, flake-utils, nixpkgs-python }:
    let
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      project_root = builtins.toString ./.;
      python_version = "3.11.6";
    in {
      devShells."x86_64-linux".default = pkgs.mkShell {

        buildInputs = [
          nixpkgs-python.packages."x86_64-linux"."${python_version}"
          pkgs.poetry
        ];

        LD_LIBRARY_PATH = "$LD_LIBRARY_PATH:${
            (pkgs.lib.makeLibraryPath [ pkgs.stdenv.cc.cc pkgs.zlib ])
          }:${project_root}/Cbc-lib/Linux-x86_64-lib/";
        PMIP_CBC_LIBRARY = "${project_root}/Cbc-lib/Linux-x86_64-lib/libCbc.so";

        shellHook = ''
          poetry install
          source $(poetry env info --path)/bin/activate
        '';
      };
    };
}
