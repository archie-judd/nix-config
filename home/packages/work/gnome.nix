{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    gnomeExtensions.tophat # system resource monitor
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.dash-to-dock
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "tophat@fflewddur.github.io"
        "clipboard-indicator@tudmotu.com"
        "dash-to-dock@micxgx.gmail.com"
      ];
    };
  };
}
