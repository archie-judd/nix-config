{ pkgs, ... }:

{
  environment.gnome.excludePackages = [
    pkgs.gnome-photos
    pkgs.gnome-tour
    pkgs.gedit
    pkgs.snapshot
    pkgs.gnome-text-editor
    pkgs.gnome-connections
    pkgs.gnome.cheese # webcam tool
    pkgs.gnome.gnome-contacts
    pkgs.gnome.gnome-clocks
    pkgs.gnome.gnome-calendar
    pkgs.gnome.gnome-music
    pkgs.gnome.gnome-terminal
    pkgs.gnome.gnome-weather
    pkgs.gnome.gnome-calculator
    pkgs.gnome.gnome-maps
    pkgs.gnome.gnome-system-monitor
    pkgs.gnome.gnome-font-viewer
    pkgs.gnome.gnome-characters
    pkgs.gnome.gnome-logs
    pkgs.gnome.gnome-disk-utility
    pkgs.gnome.file-roller
    pkgs.gnome.simple-scan
    pkgs.gnome.epiphany # web browser
    pkgs.gnome.geary # email reader
    pkgs.gnome.evince # document viewer
    pkgs.gnome.gnome-characters
    pkgs.gnome.totem # video player
    pkgs.gnome.tali # poker game
    pkgs.gnome.iagno # go game
    pkgs.gnome.hitori # sudoku game
    pkgs.gnome.atomix # puzzle game
    pkgs.gnome.yelp
  ];

  services.xserver.excludePackages = [ pkgs.xterm ];

  environment.systemPackages = [ pkgs.libgtop ];

  environment.variables = {
    GI_TYPELIB_PATH = "/run/current-system/sw/lib/girepository-1.0";
  };

}
