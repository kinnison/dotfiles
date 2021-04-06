{ ... }:

{
  programs.git = {
    enable = true;
    userName = "Daniel Silverstone";
    userEmail = "dsilvers@digital-scurf.org";
    signing = {
      key = "0x3CCEBABE206C3B69";
      signByDefault = true;
    };
    ignores = [ "target" "result" ];
    extraConfig = {
      branch.autoSetupRebase = "always";
      checkout.defaultRemote = "origin";
      init = {
        defaultBranch = "main";
      };

      pull.rebase = true;
      pull.ff = "only";
      push.default = "current";

      url."ssh://git@github.com/".pushInsteadOf = "https://github.com/";
      url."ssh://git@gitlab.com/".pushInsteadOf = "https://gitlab.com/";
    };
  };

}
