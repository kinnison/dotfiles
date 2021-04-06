# Configuration for running Daniel's preferred GUI system (mate with xmonad)
{ config, pkgs, lib, dotroot, systemConfig, ... }:
let
  xdg = config.xdg;
in
{
  # First set up the main dependencies

  home.packages = with pkgs; [
    firefox
    polybar
  ];

  # Now configure the homedir to work properly
  # Sadly? xmonad isn't very XDGish
  home.file.".xmonad" = {
    recursive = true;
    source = "${dotroot}/xmonad";
  };

  # Bring in our applications
  xdg.dataFile.applications = {
    recursive = true;
    source = "${dotroot}/desktop-files";
  };

  # Currently we do a fairly generic polybar install
  # but later we can decide how to manipulate this based
  # on the kind of system we're on (e.g. wifi vs. not)
  xdg.configFile.polybar = {
    recursive = true;
    source = "${dotroot}/polybar";
  };

  # But rather than setting it up as a desktop file for
  # the session, try using a user-thingy for graphical
  # sessions to see if that works.
  systemd.user.services.polybar = {
    Unit = {
      Description = "Polybar";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.polybar}/bin/polybar -r ${systemConfig.networking.hostName}";
      Restart = "on-failure";
    };
    Install = { WantedBy = [ "graphical-session.target" ]; };
  };

  # Now we need to do some dconfery to ensure that we don't launch the panel
  # and that the chosen window manager is xmonad.
  dconf = {
    enable = true;
    settings."org/mate/desktop/session/required-components" = {
      windowmanager = "xmonad";
    };
    settings."org/mate/desktop/session" = {
      required-components-list = lib.hm.gvariant.mkTuple [ "windowmanager" "filemanager" ];
    };
  };
}
