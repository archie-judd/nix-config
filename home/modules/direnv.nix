{ config, pkgs, lib, ... }:

{
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
  };

}

