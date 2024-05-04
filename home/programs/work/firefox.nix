{ config, pkgs, lib, ... }:

{
  programs.firefox = {
    enable = true;
    profiles = {
      archie = {
        containersForce = true;
        containers = {
          dev = {
            color = "green";
            id = 1;
            icon = "circle";
          };
          prod = {
            color = "red";
            id = 2;
            icon = "circle";
          };
        };
      };
    };
  };

}

