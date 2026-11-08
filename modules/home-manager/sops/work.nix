{ ... }:

{
  imports = [ ./shared.nix ];

  sops.secrets = {
    github-pat-work = {
      sopsFile = ./secrets-work.yaml;
    };
    claude-code-oauth-token-work = {
      sopsFile = ./secrets-work.yaml;
    };
  };
}
