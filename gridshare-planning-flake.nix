{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-python.url = "github:cachix/nixpkgs-python";
  };
  outputs = { self, nixpkgs, flake-utils, nixpkgs-python }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        project_root = "${toString ./.}";
        python_version = "3.11.6";
      in {
        devShell = pkgs.mkShell {
          buildInputs = [
            nixpkgs-python.packages.x86_64-linux."${python_version}"
            pkgs.poetry
          ];

          NIX_LD_LIBRARY_PATH =
            pkgs.lib.makeLibraryPath [ pkgs.stdenv.cc.cc pkgs.zlib ]
            + ":${project_root}/Cbc-lib/Linux-x86_64-lib/";
          NIX_LD = pkgs.lib.fileContents
            "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
          PMIP_CBC_LIBRARY =
            "${project_root}/Cbc-lib/Linux-x86_64-lib/libCbc.so";

          shellHook = ''
            export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
            poetry install
            source $(poetry env info --path)/bin/activate
          '';
        };
      });
}
