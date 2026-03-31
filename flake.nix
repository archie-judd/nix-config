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

    neovim-config.url = "github:archie-judd/neovim-config?ref=refs/heads/main";

    agent-sandbox-nix.url =
      "github:archie-judd/agent-sandbox.nix?ref=refs/heads/feat/unshare-net";

    bbc-to-spotify.url =
      "github:archie-judd/bbc-to-spotify?ref=refs/tags/v0.0.4";

    kolide-launcher = {
      url = "github:/kolide/nix-agent/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs:
    let overlays = import ./overlays.nix;
    in {

      nixosConfigurations = {
        thinkpad-x1 = import ./hosts/thinkpad-x1 {
          inputs = inputs;
          overlays = overlays;
        };
      };

      darwinConfigurations = {
        macbook-pro = import ./hosts/macbook-pro {
          inputs = inputs;
          overlays = overlays;
        };
      };

      # Home manager only configurations
      homeConfigurations = {
        archiejudd = import ./hosts/nuc {
          inputs = inputs;
          overlays = overlays;
        };
        archie = import ./hosts/raspberry-pi {
          inputs = inputs;
          overlays = overlays;
        };
      };
    };
}
