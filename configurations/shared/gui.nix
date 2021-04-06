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
      ExecStartPre = "sleep 2";
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
      required-components-list = [ "windowmanager" "filemanager" ];
    };
    settings."org/mate/terminal/profiles/default" = {
      background-color = "#000000000000";
      bold-color = "#000000000000";
      default-show-menubar = false;
      font = "Inconsolata 14";
      foreground-color = "#FFFFFFFFFFFF";
      palette = "#2E2E34343636:#CCCC00000000:#4E4E9A9A0606:#C4C4A0A00000:#34346565A4A4:#757550507B7B:#060698209A9A:#D3D3D7D7CFCF:#555557575353:#EFEF29292929:#8A8AE2E23434:#FCFCE9E94F4F:#72729F9FCFCF:#ADAD7F7FA8A8:#3434E2E2E2E2:#EEEEEEEEECEC";
      scrollbar-position = "hidden";
      use-system-font = false;
      use-theme-colors = false;
      visible-name = "Default";
    };
    settings."org/mate/desktop/background" = {
      show-desktop-icons = false;
      primary-color = "rgb(0,0,0)";
      secondary-color = "rgb(0,0,0)";
      color-shading-type = "vertical-gradient";
    };
    settings."org/mate/desktop/peripherals/keyboard/kbd" = {
      layouts = [ "gb" ];
      options = [ "terminate\tterminate:ctrl_alt_bksp" "Compose key\tcompose:caps" ];
    };
  };
}
