{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;
    userName = "archiejudd";
    userEmail = "archie.judd@yahoo.com";
    extraConfig = {
      init.defaultBranch = "main";
      push.default = "nothing";
    };
    ignores = [ "*~" "*.swp" ];
  };

}

