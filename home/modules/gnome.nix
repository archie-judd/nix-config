{ pkgs, pkgs-unstable, ... }:

{
  home.packages = [
    pkgs.gnomeExtensions.tophat # system resource monitor
    pkgs.gnomeExtensions.vitals # power inidicator
    pkgs.gnomeExtensions.clipboard-indicator
    pkgs.gnomeExtensions.dash-to-dock
    pkgs-unstable.gnome.pomodoro
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "clipboard-indicator@tudmotu.com"
        "dash-to-dock@micxgx.gmail.com"
        "Vitals@CoreCoding.com"
      ];
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "Alacritty.desktop"
        "firefox.desktop"
        "org.gnome.Settings.desktop"
        "slack.desktop"
        "spotify.desktop"
      ];
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      show-battery-percentage = true;
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
      help = [ ];
      home = [ ];
      magnifier = [ ];
      magnifier-zoom-in = [ ];
      magnifier-zoom-out = [ ];
      screenreader = [ ];
      screensaver = [ "<Shift><Super>q" ];
    };
    "org/gnome/desktop/wm/keybindings" = {
      begin-move = [ ];
      begin-resize = [ ];
      close = [ "<Super>q" ];
      cycle-group = [ ];
      cycle-group-backward = [ ];
      cycle-panels = [ ];
      cycle-panels-backward = [ ];
      cycle-windows = [ "<Super>n" ];
      cycle-windows-backward = [ "<Super>p" ];
      lower = [ ];
      maximize = [ ];
      minimize = [ ];
      move-to-monitor-down = [ "<Shift><Super>j" ];
      move-to-monitor-left = [ "<Shift><Super>h" ];
      move-to-monitor-right = [ "<Shift><Super>l" ];
      move-to-monitor-up = [ "<Shift><Super>k" ];
      move-to-workspace-1 = [ "<Shift><Super>1" ];
      move-to-workspace-2 = [ "<Shift><Super>2" ];
      move-to-workspace-3 = [ "<Shift><Super>3" ];
      move-to-workspace-4 = [ "<Shift><Super>4" ];
      move-to-workspace-last = [ ];
      move-to-workspace-left = [ ];
      move-to-workspace-right = [ ];
      raise = [ ];
      raise-or-lower = [ "<Super>k" ];
      switch-applications = [ "<Super>Tab" ];
      switch-applications-backward = [ "<Shift><Super>Tab" ];
      switch-group = [ "<Alt>Tab" ];
      switch-group-backward = [ "<Shift><Alt>Tab" ];
      switch-panels = [ ];
      switch-panels-backward = [ ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-to-workspace-last = [ ];
      switch-to-workspace-left = [ "<Shift><Super>p" ];
      switch-to-workspace-right = [ "<Shift><Super>n" ];
      switch-windows = [ ];
      switch-windows-backward = [ ];
      toggle-maximized = [ "<Super>z" ];
      unmaximize = [ ];
    };
    "org/gnome/mutter/keybindings" = {
      toggle-tiled-left = [ "<Super>h" ];
      toggle-tiled-right = [ "<Super>l" ];
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };
    "org/gnome/shell/keybindings" = {
      focus-active-notification = [ ];
      screenshot = [ "<Shift><Super>s" ];
      screenshot-window = [ ];
      show-screen-recording-ui = [ ];
      show-screenshot-ui = [ "<Super>s" ];
      switch-to-application-1 = [ ];
      switch-to-application-2 = [ ];
      switch-to-application-3 = [ ];
      switch-to-application-4 = [ ];
      toggle-quick-settings = [ ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" =
      {
        binding = "<Super>t";
        command = "alacritty -e tmux";
        name = "Terminal";
      };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" =
      {
        binding = "<Super>b";
        command = "firefox";
        name = "Browser";
      };
    "org/gnome/shell/extensions/dash-to-dock" = {
      animate-show-apps = true;
      apply-custom-theme = true;
      autohide-in-fullscreen = true;
      background-opacity = 0.8;
      click-action = "cycle-windows";
      dash-max-icon-size = 48;
      dock-position = "BOTTOM";
      extend-height = false;
      height-fraction = 0.92;
      hide-tooltip = true;
      hot-keys = false;
      intellihide = false;
      intellihide-mode = "FOCUS_APPLICATION_WINDOWS";
      middle-click-action = "launch";
      multi-monitor = true;
      preferred-monitor = -2;
      preferred-monitor-by-connector = "eDP-1";
      preview-size-scale = 0.0;
      shift-click-action = "minimize";
      shift-middle-click-action = "launch";
      show-apps-always-in-the-edge = true;
      show-apps-at-top = false;
      show-windows-preview = true;
      workspace-agnostic-urgent-windows = true;
    };
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-temperature = "uint32 3090";
    };
    "org/gnome/desktop/default-applications/terminal" = {
      exec = "alacritty";
      exec-arg = "";
    };
  };

}
