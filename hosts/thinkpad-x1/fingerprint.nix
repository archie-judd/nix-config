{ pkgs, ... }:

{

  environment.systemPackages = [ pkgs.fprintd ];

  # Fingerprint reader
  # Enable fingerprint reader support
  services.fprintd.enable = true;
  # Make sure PAM is configured (usually automatic with GNOME)
  security.pam.services.gdm.fprintAuth = true;
  # Optional: enable for sudo
  security.pam.services.sudo.fprintAuth = true;

}
