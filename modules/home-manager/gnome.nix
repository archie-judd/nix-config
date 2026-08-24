{ lib, pkgs, ... }:

let
  # Ordered as the dock shows them; the keys mirror the apps table in
  # hammerspoon/init.lua, so both platforms launch-or-focus the same set.
  favourites = [
    {
      desktop = "Alacritty.desktop";
      key = "t";
    }
    {
      desktop = "com.anthropic.Claude.desktop";
      key = "c";
    }
    {
      desktop = "firefox.desktop";
      key = "b";
    }
    {
      desktop = "slack.desktop";
      key = "s";
    }
    {
      desktop = "obsidian.desktop";
      key = "o";
    }
    {
      desktop = "org.gnome.Nautilus.desktop";
      key = "f";
    }
    { desktop = "org.gnome.Settings.desktop"; }
    { desktop = "spotify.desktop"; }
  ];

  # switch-to-application-N raises the app's most recent window, or launches it
  # if it is not running. N indexes favorite-apps, hence the shared list above.
  launchOrFocus = lib.listToAttrs (
    lib.imap1 (i: app: {
      name = "switch-to-application-${toString i}";
      value = if app ? key then [ "<Super>${app.key}" ] else [ ];
    }) favourites
  );
in
{
  home.packages = [
    pkgs.gnomeExtensions.tophat # system resource monitor
    pkgs.gnomeExtensions.vitals # power inidicator
    pkgs.gnomeExtensions.clipboard-indicator
    pkgs.gnomeExtensions.dash-to-dock
    pkgs.gnomeExtensions.gnome-bedtime # bedtime greyscale filter
    pkgs.gnomeExtensions.draw-on-gnome # annotate
  ];

  # dump this with
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "clipboard-indicator@tudmotu.com"
        "dash-to-dock@micxgx.gmail.com"
        "Vitals@CoreCoding.com"
        "gnomebedtime@ionutbortis.gmail.com"
        "tophat@fflewddur.github.io"
        "draw-on-gnome@daveprowse.github.io"
      ];
      favorite-apps = map (app: app.desktop) favourites;
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      show-battery-percentage = true;
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [ ];
      help = [ ];
      home = [ ];
      magnifier = [ ];
      magnifier-zoom-in = [ ];
      magnifier-zoom-out = [ ];
      screenreader = [ ];
      screensaver = [ "<Shift><Super>q" ];
    };
    "org/gnome/shell/app-switcher".current-workspace-only = true; # only show apps from current workspace in alt-tab
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
      move-to-workspace-1 = [ ];
      move-to-workspace-2 = [ ];
      move-to-workspace-3 = [ ];
      move-to-workspace-4 = [ ];
      move-to-workspace-last = [ ];
      move-to-workspace-left = [ ];
      move-to-workspace-right = [ ];
      raise = [ ];
      raise-or-lower = [ ];
      switch-applications = [ "<Super>Tab" ];
      switch-applications-backward = [ "<Shift><Super>Tab" ];
      switch-group = [ "<Alt>Tab" ];
      switch-group-backward = [ "<Shift><Alt>Tab" ];
      switch-panels = [ ];
      switch-panels-backward = [ ];
      switch-to-workspace-1 = [ ];
      switch-to-workspace-2 = [ ];
      switch-to-workspace-3 = [ ];
      switch-to-workspace-4 = [ ];
      switch-to-workspace-last = [ ];
      switch-to-workspace-left = [ "<Shift><Super>p" ];
      switch-to-workspace-right = [ "<Shift><Super>n" ];
      switch-windows = [ ];
      switch-windows-backward = [ ];
      toggle-maximized = [ "<Super>z" ];
      unmaximize = [ ];
      switch-input-source = [ "<Super>space" ];
      switch-input-source-backward = [ "<Shift><Super>space" ];
    };
    "org/gnome/mutter/keybindings" = {
      toggle-tiled-left = [ "<Super>h" ];
      toggle-tiled-right = [ "<Super>l" ];
      switch-monitor = [ ];
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };
    "org/gnome/shell/keybindings" = {
      focus-active-notification = [ ];
      screenshot = [ ];
      screenshot-window = [ ];
      show-screen-recording-ui = [ ];
      show-screenshot-ui = [ "<Shift><Super>s" ];
      toggle-quick-settings = [ ];
      # GNOME offers nine slots; only the favourites above claim one.
      switch-to-application-9 = [ ];
    }
    // launchOrFocus;
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
