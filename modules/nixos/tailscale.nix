{ pkgs-unstable, ... }:

{

  # Enable tailscale
  services.tailscale.enable = true;
  services.tailscale.package = pkgs-unstable.tailscale;

}
