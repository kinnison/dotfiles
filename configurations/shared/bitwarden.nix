{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # This gives us the `bw` CLI tool
    pkgs.bitwarden-cli
    # And this the bwmenu tool
    local.bitwarden-rofi
  ];

  systemd.user.services.keyring-link = {
    Unit = {
      Description = "Link user and session keyrings on login";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.keyutils}/bin/keyctl link @us @s";
    };
    Install = { WantedBy = [ "graphical-session.target" ]; };
  };

  # Sadly, currently there doesn't seem to be a way to pre-configure
  # the vault and username.

}
