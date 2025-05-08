{ pkgs, ... }: {
  home.packages = [ pkgs.gromit-mpx ];
  home.file = {
    ".config/autostart/gromit-mpx.desktop" = { source = ./gromit-mpx.desktop; };
    ".config/gromit-mpx.cfg" = { source = ./gromit-mpx.cfg; };
    ".config/gromit-mpx.ini" = { source = ./gromit-mpx.ini; };
  };
}
