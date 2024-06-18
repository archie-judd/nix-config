{ pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;
    packages = [ (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];

    fontconfig = {
      defaultFonts = {
        serif = [ "JetBrainsMono" ];
        sansSerif = [ "JetBrainsMono" ];
        monospace = [ "JetBrainsMono" ];
      };
    };
  };
}
