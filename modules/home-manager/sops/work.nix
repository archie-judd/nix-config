{ ... }:

{
  imports = [ ./shared.nix ];

  sops.secrets = {
    github-pat = {
      sopsFile = ./secrets-work.yaml;
    };
  };
}
