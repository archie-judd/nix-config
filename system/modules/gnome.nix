{ pkgs, pkgs-unstable, ... }:

{
  environment.gnome.excludePackages = [
    pkgs-unstable.gnome-contacts
    pkgs-unstable.gnome-clocks
    pkgs-unstable.gnome-music
    pkgs-unstable.gnome-weather
    pkgs-unstable.gnome-maps
    pkgs-unstable.gnome-characters
    pkgs-unstable.gnome-logs
    pkgs-unstable.gnome-calendar
    pkgs-unstable.gnome-photos
    pkgs-unstable.gnome-tour
    pkgs-unstable.gnome-text-editor
    pkgs-unstable.gnome-connections
    pkgs-unstable.gnome-terminal
    pkgs-unstable.gnome-calculator
    pkgs-unstable.gnome-system-monitor
    pkgs-unstable.gnome-font-viewer
    pkgs-unstable.gnome-disk-utility
    pkgs-unstable.gedit
    pkgs-unstable.snapshot
    pkgs-unstable.cheese # webcam tool
    pkgs-unstable.file-roller
    pkgs-unstable.simple-scan
    pkgs-unstable.epiphany # web browser
    pkgs-unstable.geary # email reader
    pkgs-unstable.evince # document viewer
    pkgs-unstable.totem # video player
    pkgs-unstable.yelp # help viewer
    pkgs-unstable.tali # poker game
    pkgs-unstable.iagno # go game
    pkgs-unstable.hitori # sudoku game
    pkgs-unstable.atomix # puzzle game
  ];

  services.xserver.excludePackages = [ pkgs.xterm ];

  environment.systemPackages = [ pkgs.libgtop ];

  environment.variables = {
    GI_TYPELIB_PATH = "/run/current-system/sw/lib/girepository-1.0";
  };

}
