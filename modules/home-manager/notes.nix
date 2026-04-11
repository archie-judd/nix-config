{ config, ... }:

{
  home.sessionVariables = {
    NOTES_PATH = "${config.home.homeDirectory}/workspaces/personal/notes.md";
  };
  programs.bash.initExtra = ''
    n() {
      local file="$NOTES_PATH"
      [[ -f "$file" ]] || { mkdir -p "$(dirname "$file")" && touch "$file"; }
      case "''${1:-}" in
        "") $EDITOR "$file" ;;
        *)  printf "\n## %s\n\n%s\n" "$(date '+%F %T')" "$*" >> "$file" ;;
      esac
    }
  '';
}
