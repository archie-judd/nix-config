{ config, ... }:

{
  home.sessionVariables = {
    TASKS_PATH =
      "${config.home.homeDirectory}/workspaces/personal/notes/tasks.md";
  };
  programs.bash.initExtra = ''
    t() {
      local file="$TASKS_PATH"
      case "''${1:-}" in
        "") $EDITOR "$file" ;;
        -l) grep -n "^- \[ \]" "$file" ;;
        *)  echo "- [ ] $(date +%F) $*" >> "$file" ;;
      esac
    }
  '';
}
