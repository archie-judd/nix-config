{ config, pkgs, lib, ... }:

{
  programs.chromium = {
    enable = true;
    package = pkgs.google-chrome;
  };

}

