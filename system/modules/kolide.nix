{ config, pkgs, lib, ... }:

{
  # Kolide
  # reads secret from here: /etc/kolide-k2/secret
  services.kolide-launcher = {
    enable = true;
    enrollSecretDirectory = "/etc/kolide-k2/secret";
  };

}

