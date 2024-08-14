{ pkgs, ... }:

{
  environment.gnome.excludePackages = [
    pkgs.gnome.gnome-contacts
    pkgs.gnome.gnome-clocks
    pkgs.gnome.gnome-music
    pkgs.gnome.gnome-weather
    pkgs.gnome.gnome-maps
    pkgs.gnome.gnome-characters
    pkgs.gnome.gnome-logs
    pkgs.gnome.tali # poker game
    pkgs.gnome.iagno # go game
    pkgs.gnome.hitori # sudoku game
    pkgs.gnome.atomix # puzzle game
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
  ];

  services.xserver.excludePackages = [ pkgs.xterm ];

  environment.systemPackages = [ pkgs.libgtop ];

  environment.variables = {
    GI_TYPELIB_PATH = "/run/current-system/sw/lib/girepository-1.0";
  };

}
