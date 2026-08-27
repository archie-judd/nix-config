{ config, ... }:

{
  home.sessionVariables = {
    LOG_PATH = "${config.home.homeDirectory}/workspaces/work/log.md";
  };
  programs.bash.initExtra =
    # bash
    ''
      log() {
        local file="$LOG_PATH"
        [[ -f "$file" ]] || { mkdir -p "$(dirname "$file")" && touch "$file"; }
        $EDITOR "$file"
      }
    '';
}
