{ config, pkgs, ... }:
{
  services.handy.enable = true;
  home.packages = [
    config.services.handy.package
    pkgs.dotool
  ];

}
