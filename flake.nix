{
  description = "NixOS configuration";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";

    bbc-to-spotify.url =
      "github:archie-judd/bbc-to-spotify?ref=refs/tags/v0.0.4";

    neovim-config.url = "github:archie-judd/neovim-config?ref=refs/heads/main";

    kolide-launcher = {
      url = "github:/kolide/nix-agent/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nix-darwin
    , sops-nix, bbc-to-spotify, neovim-config, kolide-launcher, ... }:
    let
      overlays = import ./overlays;
      # Define a predicate to allow specific unfree packages
    in {

      # NixOS configurations
      nixosConfigurations = {
        thinkpad-x1 = let system = "x86_64-linux";
        in nixpkgs.lib.nixosSystem {
          system = system;
          specialArgs = {
            pkgs-unstable = import nixpkgs-unstable {
              system = system;
              config.allowUnfree = true;
            };
          };

          modules = [
            ./system/hosts/thinkpad-x1/configuration.nix
            kolide-launcher.nixosModules.kolide-launcher
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            {
              nixpkgs.overlays = [ overlays ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.archie = import ./home/users/work-laptop.nix;
              home-manager.sharedModules = [
                sops-nix.homeManagerModules.sops
              ]; # Share sops config with all modules
              home-manager.extraSpecialArgs = {
                pkgs-unstable = import nixpkgs-unstable {
                  system = system;
                  config.allowUnfree = true;
                };
                nixpkgs = nixpkgs;
                neovim-config = neovim-config;
              };
            }
          ];
        };
      };

      # Darwin configurations
      darwinConfigurations = {
        macbook-pro = let system = "aarch64-darwin";
        in nix-darwin.lib.darwinSystem {
          system = system;
          specialArgs = {
            pkgs-unstable = import nixpkgs-unstable {
              system = system;
              config.allowUnfree = true;
            };
          };
          modules = [
            ./system/hosts/macbook-pro/configuration.nix
            home-manager.darwinModules.home-manager
            {
              nixpkgs.overlays = [ overlays ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.archie = import ./home/users/personal-mac.nix;
              home-manager.extraSpecialArgs = {
                pkgs-unstable = import nixpkgs-unstable {
                  system = system;
                  config.allowUnfree = true;
                };
                neovim-config = neovim-config;
                bbc-to-spotify = bbc-to-spotify;
                nixpkgs = nixpkgs;
              };
            }
          ];
        };
      };

      # Home manager only configurations
      homeConfigurations = {
        # Work NUC
        archiejudd = let system = "x86_64-linux";
        in home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = system;
            config.allowUnfree = true;
          };
          modules = [ ./home/users/work-nuc.nix ];
          extraSpecialArgs = {
            pkgs-unstable = import nixpkgs-unstable {
              system = system;
              allowUnfree = true;
            };
            nixpkgs = nixpkgs;
            neovim-config = neovim-config;
          };
        };
        # Rpi
        archie = let system = "aarch64-linux";
        in home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = system;
            config.allowUnfree = true;
          };
          modules = [ ./home/users/personal-rpi.nix ];
          extraSpecialArgs = {
            pkgs-unstable = import nixpkgs-unstable {
              system = system;
              config.allowUnfree = true;
            };
            nixpkgs = nixpkgs;
            bbc-to-spotify = bbc-to-spotify;
          };
        };
      };
    };
}
