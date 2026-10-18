{ ... }:

{
  sops.secrets = {
    trading-212-api-key = {
      sopsFile = ./secrets-personal.yaml;
    };
    personal-git-crypt-key = {
      format = "binary";
      sopsFile = ./personal-git-crypt.key;
    };
  };
}
