{ ... }:

{
  # use 'natural scrolling'  
  system.defaults.NSGlobalDomain."com.apple.swipescrolldirection" = true;

  # dock
  system.defaults.dock.autohide = true;
  system.defaults.dock.autohide-time-modifier = 0.4;
  system.defaults.dock.show-recents = false;

  # default to list view in finder
  system.defaults.finder.FXPreferredViewStyle = "Nlsv";

  # hotcorners
  system.defaults.dock.wvous-tl-corner = 2; # top left - mission-control
  system.defaults.dock.wvous-tr-corner = 4; # top right - desktop
  system.defaults.dock.wvous-br-corner = 1; # disabled
  system.defaults.dock.wvous-bl-corner = 1; # disabled

  # whether to allow quitting of finder
  system.defaults.finder.QuitMenuItem = false;

  # whether to show the finder path bar
  system.defaults.finder.ShowPathbar = true;
  # whether to show the finder status bar
  system.defaults.finder.ShowStatusBar = false;

  # trackpad speed (1.0 - 3.0)
  system.defaults.NSGlobalDomain."com.apple.trackpad.scaling" = 3.0;

  # disable startup chime
  system.startup.chime = false;
}
