{ config, ... }:

{
  home.sessionVariables = {
    TASKS_PATH = "${config.home.homeDirectory}/workspaces/personal/tasks.md";
  };
  programs.bash.initExtra = ''
    t() {
      local file="$TASKS_PATH"
      [[ -f "$file" ]] || { mkdir -p "$(dirname "$file")" && touch "$file"; }
      case "''${1:-}" in
        "") $EDITOR "$file" ;;
        -l) grep -n "^- \[ \]" "$file" ;;
        *)  echo "- [ ] $(date +%F) $*" >> "$file" ;;
      esac
    }
  '';
}
