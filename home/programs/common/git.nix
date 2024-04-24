{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;
    userName = "archiejudd";
    userEmail = "archie.judd@yahoo.com";
    extraConfig = {
      init.defaultBranch = "main";
      safe.Directory = "/etc/nixos";
      push.default = "nothing";
    };
  };

}

