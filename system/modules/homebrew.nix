{ ... }:

{
  # Install GUI programs and AppStore apps with homebrew. Does not install homebrew!
  homebrew = {
    enable = true;
    casks = [
      "steam"
      "1password"
      "karabiner-elements"
      "vlc"
      "rectangle"
      "spotify"
      "maccy"
      "google-chrome"
      "whatsapp"
      "discord"
    ];
    masApps = {
      "1Password for Safari" = 1569813296;
      "istat Menus" = 1319778037;
    };
  };
}
