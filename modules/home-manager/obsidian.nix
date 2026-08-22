{
  lib,
  config,
  pkgs,
  ...
}:

{
  programs.obsidian = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then null else pkgs.obsidian;
    defaultSettings = {
      app = {
        vimMode = true;
        defaultViewMode = "preview";
        attachmentFolderPath = "attachments";
      };
      appearance = {
        theme = "obsidian";
        nativeMenus = false;
      };
      corePlugins = [
        "file-explorer"
        "global-search"
        "switcher"
        "backlink"
        "command-palette"
        "outline"
      ];
      communityPlugins = [ ];
    };
    vaults = {
      "${config.home.homeDirectory}/workspaces/reference" = {
        enable = true;
      };
    }
    // lib.attrsets.optionalAttrs pkgs.stdenv.isLinux {
      "${config.home.homeDirectory}/workspaces/work" = {
        enable = true;
      };
    }
    // lib.attrsets.optionalAttrs pkgs.stdenv.isDarwin {
      "${config.home.homeDirectory}/workspaces/personal" = {
        enable = true;
      };
    };
  };
}
