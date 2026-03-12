{ pkgs, ... }:

let
  git-branch-delete = pkgs.writeShellScriptBin "git-branch-delete"
    (builtins.readFile ./scripts/git-branch-rm.sh);
  git-tag-delete = pkgs.writeShellScriptBin "git-tag-delete"
    (builtins.readFile ./scripts/git-tag-rm.sh);
  git-worktree-add = pkgs.writeShellScriptBin "git-worktree-add"
    (builtins.readFile ./scripts/git-tag-rm.sh);
  git-worktree-delete = pkgs.writeShellScriptBin "git-worktree-delete"
    (builtins.readFile ./scripts/git-tag-rm.sh);
  gitWorktreeSwitchSource = builtins.readFile ./scripts/git-worktree-switch.sh;

in {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "archiejudd";
        email = "archiejudd@proton.me";
      };
      init.defaultBranch = "main";
      push.default = "nothing";
    };
    ignores = [
      "*~"
      "*.swp"
      "*.swo"
      ".DS_Store"
      "fontlist-v330.json"
      ".copilot/"
      ".claude/"
      ".worktrees/"
    ];
  };

  home.packages =
    [ git-branch-delete git-tag-delete git-worktree-add git-worktree-delete ];

  programs.bash.initExtra = ''
    source ${pkgs.git}/share/bash-completion/completions/git
    __git_complete git-branch-delete _git_switch
    __git_complete git-tag-delete _git_switch
  '' +
    # can't be writeShellScriptBin because cd in a subshell wouldn't change the directory of the parent shell
    # the parent shell
    gitWorktreeSwitchSource;

  program.bash.shellAliases = {
    "gbd" = "git-branch-delete";
    "gtd" = "git-tag-delete";
    "gwa" = "git-worktree-add";
    "gwd" = "git-worktree-delete";
    "gws" = "git-worktree-switch";
  };

}
