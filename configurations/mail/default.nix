{ config, pkgs, dotroot, ... }:

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
  home.packages = with pkgs; [ neomutt ];

  programs = {
    mbsync.enable = true;
    msmtp.enable = true;
    mu.enable = true;
    neomutt = {
      enable = true;
      sidebar = {
        enable = true;
        shortPath = true;
        format = "%D%?F? [%F]?%* %?N?%N/?%S";
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

  accounts.email.maildirBasePath = maildirBase;
}
