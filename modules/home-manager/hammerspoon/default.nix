{ ... }: {
  # init.lua watches this directory and reloads itself, so no onChange hook.
  home.file.".hammerspoon/init.lua".source = ./init.lua;
}
