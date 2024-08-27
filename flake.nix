{
  description = "NixOS configuration";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    bbc-to-spotify.url =
      "github:archie-judd/bbc-to-spotify?ref=refs/tags/v0.0.3";

    neovim-config.url = "github:archie-judd/neovim-config?ref=refs/tags/v0.0.1";

    kolide-launcher = {
      url = "github:/kolide/nix-agent/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Peg fzf to the gridshare-edge version to avoid conflicts.
    nixpkgs-fzf.url =
      "github:nixos/nixpkgs/a2eb207f45e4a14a1e3019d9e3863d1e208e2295";
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, nix-darwin
    , bbc-to-spotify, neovim-config, kolide-launcher, nixpkgs-fzf, ... }: {

      nixosConfigurations = {
        xps-9510 = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            pkgs-unstable = import nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };
          };
          modules = [
            ./system/hosts/xps-9510/configuration.nix
            kolide-launcher.nixosModules.kolide-launcher
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.archie = import ./home/users/work.nix;
              home-manager.extraSpecialArgs = {
                pkgs-fzf = import nixpkgs-fzf { inherit system; };
                pkgs-unstable = import nixpkgs-unstable {
                  inherit system;
                  config.allowUnfree = true;
                };
                neovim-config = neovim-config;
              };
            }
          ];
        };
      };

      darwinConfigurations = {
        macbook-pro = nix-darwin.lib.darwinSystem rec {
          system = "aarch64-darwin";
          specialArgs = {
            pkgs-unstable = import nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };
          };
          modules = [
            ./system/hosts/macbook-pro/configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.archie = import ./home/users/personal.nix;
              home-manager.extraSpecialArgs = {
                pkgs-fzf = import nixpkgs-fzf { inherit system; };
                pkgs-unstable = import nixpkgs-unstable {
                  inherit system;
                  config.allowUnfree = true;
                };
                neovim-config = neovim-config;
                bbc-to-spotify = bbc-to-spotify;
              };
            }
          ];
        };
      };
    };
}
