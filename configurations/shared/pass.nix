{ config, pkgs, ... }:

{
  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
  };
  services.git-sync = {
    enable = true;
    repositories = {
      passStore = {
        interval = 3600;
        path = config.programs.password-store.settings.PASSWORD_STORE_DIR;
        uri =
          "ssh://gitano@git.gitano.org.uk/personal/dsilvers/password-store.git";
      };
    };
  };
  # Ensure the password store things are in the systemd session
  systemd.user.sessionVariables = config.programs.password-store.settings;
}
