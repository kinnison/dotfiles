{ config, pkgs, ... }: {
  # According to Tristan, this works around https://github.com/nix-community/home-manager/issues/249
  systemd.user.services.mbsync.Service.Environment =
    "PATH=${pkgs.sops}/bin:${pkgs.gnupg}/bin";

  accounts.email.accounts = {
    "home" = {
      address = "dsilvers@digital-scurf.org";
      primary = true;
      realName = "Daniel Silverstone";
      userName = "dsilvers@digital-scurf.org";
      passwordCommand =
        "PASSWORD_STORE_DIR=${config.xdg.dataHome}/password-store ${pkgs.pass}/bin/pass personal/mail.pepperfish.net/dsilvers@digital-scurf.org | ${pkgs.coreutils}/bin/head -1 | ${pkgs.coreutils}/bin/tr -d '\\n'";
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
      };
      neomutt = {
        enable = true;
        sendMailCommand = "msmtp --read-recipients";
        extraConfig = ''
          named-mailboxes `find ${config.accounts.email.maildirBasePath}/home -type d ! \( -path ${config.accounts.email.maildirBasePath}/home -or -name new -or -name cur -or -name tmp \) -printf '"%P" =%P '`
        '';
      };
      signature = {
        showSignature = "append";
        text = ''
          Daniel Silverstone                         http://www.digital-scurf.org/
          PGP mail accepted and encouraged.            Key Id: 3CCE BABE 206C 3B69
        '';
      };
      mu.enable = true;
    };
  };

  services.mbsync.enable = true;
}
