{
  config,
  ...
}:

{
  programs.obsidian = {
    enable = true;
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
    vaults."${config.home.homeDirectory}/workspaces/notes" = {
      enable = true;
    };
  };
}
