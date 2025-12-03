{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "archiejudd";
        email = "archie.judd@yahoo.com";
      };
      init.defaultBranch = "main";
      push.default = "nothing";
    };
    ignores = [ "*~" "*.swp" "*.swo" ".DS_Store" "fontlist-v330.json" ];
  };

}

