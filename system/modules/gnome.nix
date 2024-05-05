{ config, pkgs, lib, ... }:

{
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    gedit
    snapshot
    gnome-text-editor
    gnome-connections
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-contacts
    gnome-clocks
    gnome-calendar
    gnome-music
    gnome-terminal
    gnome-weather
    gnome-calculator
    gnome-maps
    gnome-system-monitor
    gnome-font-viewer
    gnome-characters
    gnome-logs
    gnome-disk-utility
    file-roller
    simple-scan
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
    yelp
  ]);

  services.xserver.excludePackages = [ pkgs.xterm ];

  environment.systemPackages = with pkgs; [ libgtop ];

  environment.variables = {
    GI_TYPELIB_PATH = "/run/current-system/sw/lib/girepository-1.0";
  };

}
