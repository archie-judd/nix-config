{ config, pkgs, lib, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  hardware = {
    opengl.enable = true;
    nvidia.modesetting.enable = true;
  };

  environment.systemPackages = [
    pkgs.waybar
    pkgs.swaynotificationcenter
    pkgs.networkmanagerapplet
    pkgs.libnotify
    pkgs.blueman
    pkgs.rofi-wayland
    pkgs.vifm
  ];

  environment.sessionVariables = { NIXOS_OZONE_WL = "1"; };
  #xdg.portal.enable = true;
  #xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}
