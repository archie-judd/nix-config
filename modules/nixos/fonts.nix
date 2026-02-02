{ pkgs, ... }:

{
  fonts = {
    packages = [ pkgs.nerd-fonts.sauce-code-pro ];
    enableDefaultPackages = true;
    fontconfig = {
      defaultFonts = {
        serif = [ "SourceCodePro" ];
        sansSerif = [ "SourceCodePro" ];
        monospace = [ "SourceCodePro" ];
      };
    };
  };
}
