{ pkgs, ... }:

{
  environment.gnome.excludePackages = [
    pkgs.gnome-photos
    pkgs.gnome-tour
    pkgs.gedit
    pkgs.snapshot
    pkgs.gnome-text-editor
    pkgs.gnome-connections
    pkgs.cheese # webcam tool
    pkgs.gnome-contacts
    pkgs.gnome-clocks
    pkgs.gnome-calendar
    pkgs.gnome-music
    pkgs.gnome-terminal
    pkgs.gnome-weather
    pkgs.gnome-calculator
    pkgs.gnome-maps
    pkgs.gnome-system-monitor
    pkgs.gnome-font-viewer
    pkgs.gnome-characters
    pkgs.gnome-logs
    pkgs.gnome-disk-utility
    pkgs.file-roller
    pkgs.simple-scan
    pkgs.epiphany # web browser
    pkgs.geary # email reader
    pkgs.evince # document viewer
    pkgs.gnome-characters
    pkgs.totem # video player
    pkgs.tali # poker game
    pkgs.iagno # go game
    pkgs.hitori # sudoku game
    pkgs.atomix # puzzle game
    pkgs.yelp
  ];

  services.xserver.excludePackages = [ pkgs.xterm ];

  environment.systemPackages = [ pkgs.libgtop ];

  environment.variables = {
    GI_TYPELIB_PATH = "/run/current-system/sw/lib/girepository-1.0";
  };

}
