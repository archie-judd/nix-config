{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        _poetry2nix = poetry2nix.lib.mkPoetry2Nix { inherit pkgs; };

        my_env = _poetry2nix.mkPoetryEnv {

          projectDir = ./.;
          editablePackageSources = {
            gridshare_planning = "${builtins.getEnv "PWD"}/src";
          };
          preferWheels = true;
          groups = [ "dev" "test" ];

          overrides = _poetry2nix.defaultPoetryOverrides.extend (self: super: {

            cvxopt = super.cvxopt.overridePythonAttrs (old: {
              buildInputs = (old.buildInputs or [ ])
                ++ [ pkgs.blas pkgs.lapack pkgs.suitesparse ];
            });

            pypika = super.pypika.overridePythonAttrs (old: {
              buildInputs = (old.buildInputs or [ ]) ++ [ super.setuptools ];
            });

            mapq = super.mapq.overridePythonAttrs (old: {
              buildInputs = (old.buildInputs or [ ]) ++ [ super.setuptools ];
            });

            darksky = super.darksky.overridePythonAttrs (old: {
              buildInputs = (old.buildInputs or [ ]) ++ [ super.setuptools ];
            });

            numba = super.numba.overridePythonAttrs (old: {
              buildInputs = (old.buildInputs or [ ])
                ++ [ pkgs.gcc pkgs.tbb_2021_11 pkgs.llvm ];
            });

            h3 =
              (super.h3.override { preferWheel = false; }).overridePythonAttrs
              (old: {
                pname = "h3";
                version = "3.7.6";
                src = pkgs.fetchFromGitHub {
                  owner = "uber";
                  repo = "h3-py";
                  rev = "refs/tags/v3.7.6";
                  hash = "sha256-QNiuiHJ4IMxpi39iobPSSlYUUj5oxpxO4B2+HXVQ/Zk=";
                };
              });

            lambda-multiprocessing =
              super.lambda-multiprocessing.overridePythonAttrs (old: rec {
                pname = "lambda_multiprocessing";
                src = pkgs.fetchPypi {
                  inherit pname;
                  inherit (old) version;
                  sha256 =
                    "sha256-zEAbJ74k6R5Lv2zGlDavlCDDPlHhoD0OmhgAYijOHIc=";
                };
              });

          });
        };
      in {
        devShells.default = pkgs.mkShell {
          inputsFrom = [ my_env.env ];
          packages = [ pkgs.poetry ];
        };
      });
}
