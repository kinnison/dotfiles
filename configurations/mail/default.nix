{ config, pkgs, dotroot, lib, ... }:

let
  maildirBase = "${config.xdg.dataHome}/mail";
  muttConfig = ''
    set edit_headers = yes
    set fast_reply = yes
    set postpone = ask-no
    set read_inc = '100'
    set reverse_alias = yes
    set rfc2047_parameters = yes
    set charset = 'utf-8'
    set markers = no
    set menu_scroll = yes
    set write_inc = '100'
    set pgp_verify_command = '${pkgs.gnupg}/bin/gpg --status-fd=2 --verbose --batch --output - --verify-options show-uid-validity --verify %s %f'
    set beep_new = yes
    set collapse_unread = no
    set delete = yes
    set move = no
    set mime_forward = ask-yes
    set use_envelope_from = yes
    set quit = ask-no
    set suspend = no
    set mark_old = no
    set wait_key = no
  '';
  muttColours = ''
    color index brightwhite default .

    color index brightblue default ~N
    color index brightblue default ~O
    color index brightmagenta default ~F
    color index red default ~D
    color index yellow default ~T


    color normal            brightwhite     default
    color indicator         brightyellow    red
    color signature         blue            default
    color quoted            brightblue      default
    color quoted1           brightcyan      default
    color quoted2           brightmagenta   default
    color quoted3           brightblue      default
    color quoted4           brightcyan      default
    color quoted5           brightmagenta   default
    color attachment        yellow          default
    color error             brightred       default
    color hdrdefault        cyan            default
    color markers           brightcyan      default
    color message           brightcyan      default
    color search            default         green
    color status            yellow          blue
    color tilde             magenta         default
    color tree              magenta         default
    color sidebar_new       brightyellow    default
    color sidebar_flagged   brightred       default
  '';
  muttHeaders = ''
    ignore *

    unignore from to cc subject date list-id
  '';
in {
  config.home.packages = with pkgs; [ neomutt ];

  options.accounts.email.accounts = with lib;
    mkOption { type = with types; attrsOf (submodule (import ./options.nix)); };

  config.programs = {
    mbsync.enable = true;
    msmtp.enable = true;
    mu.enable = true;
    neomutt = {
      enable = true;
      sidebar = {
        enable = true;
        shortPath = true;
        format = "%D%?F? [%F]?%* %?N?%N/?%?S?%S?";
        width = 30;
      };
      checkStatsInterval = 60;
      editor = "vim +/^$ ++1";
      extraConfig = ''
        # General config
        ${muttConfig}

        # Colours
        ${muttColours}

        # Headers
        ${muttHeaders}
      '';
      binds = [
        {
          map = "index";
          key = "<esc>,";
          action = "sidebar-prev";
        }
        {
          map = "index";
          key = "<esc>.";
          action = "sidebar-next";
        }
        {
          map = "index";
          key = "<esc><enter>";
          action = "sidebar-open";
        }
        {
          map = "index";
          key = "<esc><return>";
          action = "sidebar-open";
        }
        {
          map = "index";
          key = "<esc><space>";
          action = "sidebar-open";
        }
      ];
      macros = [
        {
          map = "index";
          key = "<esc>n";
          action = "<limit>~N<enter>";
        }
        {
          map = "index";
          key = "<esc>V";
          action = "<change-folder-readonly>${maildirBase}/mu<enter>";
        }
        {
          map = "index";
          key = "V";
          action =
            "<change-folder-readonly>${maildirBase}/mu<enter><shell-escape>mu find --format=links --linksdir=${maildirBase}/mu --clearlinks ";
        }
      ];
    };
  };

  config.accounts.email.maildirBasePath = maildirBase;

  config.services.mbsync = {
    preExec = "${config.xdg.dataHome}/mail/.presync";
    postExec = "${config.xdg.dataHome}/mail/.postsync";
    frequency = "*:0/3";
  };

  config.services.imapnotify.enable = true;

  config.xdg.dataFile."mail/.postsync" = {
    executable = true;
    text = ''
      #!/bin/sh

      ${pkgs.mu}/bin/mu index
    '';
  };

  config.xdg.dataFile."mail/.presync" = {
    executable = true;
    text = with lib;
      let
        mbsyncAccounts = filter (a: a.mbsync.enable)
          (attrValues config.accounts.email.accounts);
      in ''
        #!/bin/sh

        for account in ${concatMapStringsSep " " (a: a.name) mbsyncAccounts}; do
          target="${config.xdg.dataHome}/mail/$account/.null"
          ${pkgs.coreutils}/bin/ln -sf /dev/null "$target"
        done
      '';
  };

  # We use msmtpq to send email, which means if we save the mail offline we
  # can run this queue runner from time to time.
  config.systemd.user.services.msmtp-queue-runner = {
    Unit = { Description = "msmtp-queue runner"; };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.msmtp}/bin/msmtp-queue -r";
    };
  };

  config.systemd.user.timers.msmtp-queue-runner = {
    Unit = { Description = "msmtp-queue runner"; };
    Timer = {
      Unit = "msmtp-queue-runner.service";
      OnCalendar = "*:0/5";
    };
    Install = { WantedBy = [ "timers.target" ]; };
  };
}
