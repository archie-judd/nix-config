{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    gnomeExtensions.tophat # system resource monitor
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.dash-to-dock
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "tophat@fflewddur.github.io"
        "clipboard-indicator@tudmotu.com"
        "dash-to-dock@micxgx.gmail.com"
      ];
    };
    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>c" ];
      cycle-windows = [ "<Super>n" ];
      cycle-windows-backward = [ "<Super>p" ];
      lower = [ "<Super>b" ];
      maximize = "disabled";
      minimize = "disabled";
      raise = [ "<Super>f" ];
      raise-or-lower = "disabled";
      switch-windows = "disabled";
      switch-windows-backward = "disabled";
      toggle-maximized = [ "<Super>z" ];
    };
    "org/gnome/mutter/keybindings" = {
      toggle-tiled-left = [ "<Super>h" ];
      toggle-tiled-right = [ "<Super>l" ];
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      screensaver = [ "<Shift><Super>l" ];
    };
  };

}
