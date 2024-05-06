{ config, pkgs, lib, ... }:

{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs;
      [ (nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];

    fontconfig = {
      defaultFonts = {
        serif = [ "JetBrainsMono" ];
        sansSerif = [ "JetBrainsMono" ];
        monospace = [ "JetBrainsMono" ];
      };
    };
  };
}
