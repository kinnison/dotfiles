{ config, dotroot, homeDirectory, ... }:
let
  # You can remove this dodgy set after 21.05 (see below) and replace it with
  # gpgcfg = config.programs.gpg;
  gpgcfg = { homedir = ".gnupg"; };
in {
  programs.gh = {
    enable = true;
    settings = { git_protocol = "ssh"; };
  };

  programs.git = {
    enable = true;
    userName = "Daniel Silverstone";
    userEmail = "dsilvers@digital-scurf.org";
    signing = {
      key = "0x3CCEBABE206C3B69";
      signByDefault = true;
    };
    ignores = [ "target" "result" ".direnv/" ];
    extraConfig = {
      branch.autoSetupRebase = "always";
      checkout.defaultRemote = "origin";
      init = { defaultBranch = "main"; };

      pull.rebase = true;
      pull.ff = "only";
      push.default = "current";

      format.signoff = true;

      rebase.autosquash = true;

      url."ssh://git@github.com/".pushInsteadOf =
        [ "git://github.com/" "https://github.com/" ];
      url."ssh://git@gitlab.com/".pushInsteadOf =
        [ "git://gitlab.com/" "https://gitlab.com/" ];
      url."ssh://nsgit@git.netsurf-browser.org/".pushInsteadOf =
        [ "git://git.netsurf-browser.org/" "https://git.netsurf-browser.org/" ];
      alias = { st = "status"; };
    };
  };

  # Since Git uses GnuPG to sign things...

  programs.gpg = {
    # TODO: See if we can shift this into ~/.config eventually
    # Sadly `homedir` is not available until 21.05 of home-manager
    # homedir = "${homeDirectory}/.gnupg";
    enable = true;
    settings = {
      no-default-keyring = true;
      keyring = "managed.kbx";
      primary-keyring = "pubring.kbx";
    };
  };

  home.file."${gpgcfg.homedir}/managed.kbx" = {
    source = "${dotroot}/gnupg-keyring.kbx";
  };
}
