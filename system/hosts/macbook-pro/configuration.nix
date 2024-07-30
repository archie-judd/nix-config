{ pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [ pkgs.vim ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  # programs.zsh.enable = true; # default shell on catalina

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  #ADDITIONS:

  nixpkgs.config.allowUnfree = true;
  nix.extraOptions = "experimental-features = nix-command flakes";

  environment.shells = [ pkgs.bash ];
  # include bash as a system-wide shell
  programs.bash.enable = true;
  # set bash as default for my user
  users.users.archie = {
    home = "/Users/archie";
    shell = pkgs.bash;
  };

  imports = [ ../../modules/fonts.nix ];
  # don't try to symlink the json, it breaks stuff
  services.karabiner-elements.enable = true;

  system.defaults.dock.autohide = true;
  system.defaults.dock.autohide-time-modifier = 0.75;
  system.defaults.dock.show-recents = false;

  system.defaults.NSGlobalDomain."com.apple.trackpad.scaling" = 3.0;
}
