{ pkgs, ... }:

{
  environment.gnome.excludePackages = [
    pkgs.gnome-contacts
    pkgs.gnome-clocks
    pkgs.gnome-music
    pkgs.gnome-weather
    pkgs.gnome-maps
    pkgs.gnome-characters
    pkgs.gnome-logs
    pkgs.gnome-calendar
    pkgs.gnome-photos
    pkgs.gnome-tour
    pkgs.gnome-text-editor
    pkgs.gnome-connections
    pkgs.gnome-terminal
    pkgs.gnome-calculator
    pkgs.gnome-system-monitor
    pkgs.gnome-font-viewer
    pkgs.gnome-disk-utility
    pkgs.gedit
    pkgs.snapshot
    pkgs.cheese # webcam tool
    pkgs.file-roller
    pkgs.simple-scan
    pkgs.epiphany # web browser
    pkgs.geary # email reader
    pkgs.evince # document viewer
    pkgs.totem # video player
    pkgs.yelp # help viewer
    pkgs.tali # poker game
    pkgs.iagno # go game
    pkgs.hitori # sudoku game
    pkgs.atomix # puzzle game
  ];

  services.xserver.excludePackages = [ pkgs.xterm ];

  environment.systemPackages = [ pkgs.libgtop ];

  environment.variables = {
    GI_TYPELIB_PATH = "/run/current-system/sw/lib/girepository-1.0";
  };

}
