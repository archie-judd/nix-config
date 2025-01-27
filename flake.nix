{
  description = "NixOS configuration";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    bbc-to-spotify.url =
      "github:archie-judd/bbc-to-spotify?ref=refs/tags/v0.0.4";

    neovim-config.url = "github:archie-judd/neovim-config?ref=refs/heads/main";

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
            pkgs-unstable = import nixpkgs-unstable { inherit system; };
          };
          modules = [
            ./system/hosts/xps-9510/configuration.nix
            kolide-launcher.nixosModules.kolide-launcher
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.archie = import ./home/users/work-laptop.nix;
              home-manager.extraSpecialArgs = {
                pkgs-unstable = import nixpkgs-unstable { inherit system; };
                pkgs-fzf = import nixpkgs-fzf { system = system; };
                neovim-config = neovim-config;
                nixpkgs = nixpkgs;
              };
            }
          ];
        };
        thinkpad-x1 = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            pkgs-unstable = import nixpkgs-unstable { inherit system; };
          };
          modules = [
            ./system/hosts/thinkpad-x1/configuration.nix
            kolide-launcher.nixosModules.kolide-launcher
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.archie = import ./home/users/work-laptop.nix;
              home-manager.extraSpecialArgs = {
                pkgs-unstable = import nixpkgs-unstable { inherit system; };
                pkgs-fzf = import nixpkgs-fzf { system = system; };
                nixpkgs = nixpkgs;
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
            pkgs-unstable = import nixpkgs-unstable { inherit system; };
          };
          modules = [
            ./system/hosts/macbook-pro/configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.archie = import ./home/users/personal.nix;
              home-manager.extraSpecialArgs = {
                pkgs-unstable = import nixpkgs-unstable { inherit system; };
                pkgs-fzf = import nixpkgs-fzf { system = system; };
                neovim-config = neovim-config;
                bbc-to-spotify = bbc-to-spotify;
                nixpkgs = nixpkgs;
              };
            }
          ];
        };
      };
      homeConfigurations = rec {
        system = "x86_64-linux";
        archiejudd = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { inherit system; };
          modules = [ ./home/users/work-nuc.nix ];
          extraSpecialArgs = {
            pkgs-unstable = import nixpkgs-unstable { inherit system; };
            pkgs-fzf = import nixpkgs-fzf { system = system; };
            nixpkgs = nixpkgs;
            neovim-config = neovim-config;
          };
        };
      };
    };
}
