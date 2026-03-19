{ config, pkgs, ... }:

let
  git-branch-delete = pkgs.writeShellScriptBin "git-branch-delete"
    (builtins.readFile ./scripts/git-branch-delete.sh);
  git-tag-delete = pkgs.writeShellScriptBin "git-tag-delete"
    (builtins.readFile ./scripts/git-tag-delete.sh);
  git-worktree-remove = pkgs.writeShellScriptBin "git-worktree-remove"
    (builtins.readFile ./scripts/git-worktree-remove.sh);
  gitWorktreeSwitchSource = builtins.readFile ./scripts/git-worktree-switch.sh;
  gitWorktreeAddSource = builtins.readFile ./scripts/git-worktree-add.sh;
  gitCompletionsSource = builtins.readFile ./scripts/git-completions.sh;

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
    extraConfig = {
      credential.helper =
        if pkgs.stdenv.isDarwin then "osxkeychain" else "store";
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

  home.packages = [ git-branch-delete git-tag-delete git-worktree-remove ];

  programs.bash = {
    initExtra = ''
      source ${pkgs.git}/share/bash-completion/completions/git
      __git_complete git-branch-delete _git_switch
      __git_complete git-tag-delete _git_switch
      __git_complete gbd _git_switch
      __git_complete gtd _git_switch
    '' +
      # can't be writeShellScriptBin because cd in a subshell wouldn't change the directory of the parent shell
      # the parent shell
      gitWorktreeSwitchSource + gitWorktreeAddSource + gitCompletionsSource;
    shellAliases = {
      "gbd" = "git-branch-delete";
      "gtd" = "git-tag-delete";
      "gwa" = "git-worktree-add";
      "gwr" = "git-worktree-remove";
      "gws" = "git-worktree-switch";
    };
  };

}
