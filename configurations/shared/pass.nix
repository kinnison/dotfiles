{ config, pkgs, ... }:

{
  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
  };
  services.password-store-sync.enable = true;

  # Ensure the password store things are in the systemd session
  systemd.user.sessionVariables = config.programs.password-store.settings;
}
