{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-python.url = "github:cachix/nixpkgs-python";
  };

  outputs = { self, nixpkgs, flake-utils, nixpkgs-python }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python_version = "3.11.6";
        project_root = builtins.toString ./.;
        fhs = pkgs.buildFHSUserEnv {
          name = "poetry-env";
          targetPkgs = pkgs: [
            pkgs.poetry
            nixpkgs-python.packages.${system}."${python_version}"

            pkgs.stdenv.cc.cc.lib
            pkgs.gcc
            pkgs.zlib
          ];
          profile = ''
            export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${
              with pkgs;
              lib.makeLibraryPath [ pkgs.stdenv.cc.cc.lib ]
            }:${project_root}/Cbc-lib/Linux-x86_64-lib/";
            export PMIP_CBC_LIBRARY="${project_root}/Cbc-lib/Linux-x86_64-lib/libCbc.so";
          '';

          runScript = "bash";
        };
      in { devShell = fhs.env; });
}
