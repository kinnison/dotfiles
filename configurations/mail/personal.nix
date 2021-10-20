{ systemConfig, config, pkgs, folder-config, homeDirectory, ... }: {
  # According to Tristan, this works around https://github.com/nix-community/home-manager/issues/249
  systemd.user.services.mbsync.Service.Environment =
    "PATH=${pkgs.sops}/bin:${pkgs.gnupg}/bin";

  xdg.configFile."neomutt/.personal-email-password" = {
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash

      ${pkgs.pass}/bin/pass personal/mail.pepperfish.net/dsilvers@digital-scurf.org | ${pkgs.coreutils}/bin/head -1 | ${pkgs.coreutils}/bin/tr -d '\n'
    '';
  };
  accounts.email.accounts = {
    "home" = {
      address = "dsilvers@digital-scurf.org";
      primary = true;
      realName = "Daniel Silverstone";
      userName = "dsilvers@digital-scurf.org";
      passwordCommand =
        "${homeDirectory}/.config/neomutt/.personal-email-password";
      imap = {
        host = "mail.pepperfish.net";
        port = 993;
      };
      smtp = {
        host = "mail.pepperfish.net";
        port = 587;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };
      mbsync = {
        create = "both";
        remove = "maildir";
        expunge = "both";
        enable = true;
      };
      msmtp = {
        enable = true;
        extraConfig.from = "dsilvers@digital-scurf.org";
        extraConfig.domain = systemConfig.networking.hostName;
      };
      neomutt = {
        enable = true;
        sendMailCommand = "msmtpq --read-recipients";
        extraConfig = (folder-config config.accounts.email.accounts);
      };
      display-folders = [
        "Inbox"
        "listmaster"
        "Canonical"
        "Github"
        "Gitlab"
        "Family"
        "GPG"
        "RSS"
        "Lists"
        "Lists/Debian"
        "Lists/Debian/Devel-Announce"
        "Lists/Debian/UK"
        "Lists/Gitano"
        "Lists/Lua"
        "Lists/netsurf"
        "Lists/netsurf/commits"
        "Lists/netsurf/users"
        "Sent"
        "Old"
      ];
      signature = {
        showSignature = "append";
        text = ''
          Daniel Silverstone                         http://www.digital-scurf.org/
          PGP mail accepted and encouraged.            Key Id: 3CCE BABE 206C 3B69
        '';
      };
      mu.enable = true;
      imapnotify = {
        enable = true;
        boxes = [ "INBOX" "Github" "Gitlab" ];
        onNotify = "systemctl --user start mbsync.service";
      };
    };
  };

  services.mbsync.enable = true;
}
