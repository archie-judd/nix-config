{
  description = "NixOS configuration";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-claude-desktop.url = "github:minegameYTB/nixpkgs/add/claude-desktop";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix/fe7b4228405aeac2ce7192c2049a6e2bc8637082";

    neovim-config.url = "github:archie-judd/neovim-config?ref=refs/heads/main";

    agent-sandbox-nix.url = "github:archie-judd/agent-sandbox.nix?ref=refs/tags/v5.10.0";

    bbc-to-spotify.url = "github:archie-judd/bbc-to-spotify?ref=refs/tags/v0.0.8";

    kolide-launcher = {
      url = "github:kolide/nix-agent/faddc6b4250ddf6cdc341b999b7b9b162f874c89";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    handy.url = "github:cjpais/Handy?ref=refs/tags/v0.10.0";

  };

  outputs =
    inputs:
    let
      overlays = import ./overlays.nix;
    in
    {

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
