{ systemConfig, config, pkgs, folder-config, ... }: {
  # According to Tristan, this works around https://github.com/nix-community/home-manager/issues/249
  systemd.user.services.mbsync.Service.Environment =
    "PATH=${pkgs.sops}/bin:${pkgs.gnupg}/bin";

  accounts.email.accounts = {
    "test" = {
      address = "test@digital-scurf.org";
      primary = !(builtins.hasAttr "home" config.accounts.email.accounts);
      realName = "Daniel Silverstone";
      userName = "test@digital-scurf.org";
      passwordCommand =
        "PASSWORD_STORE_DIR=${config.xdg.dataHome}/password-store ${pkgs.pass}/bin/pass personal/mail.pepperfish.net/test@digital-scurf.org | ${pkgs.coreutils}/bin/head -1 | ${pkgs.coreutils}/bin/tr -d '\\n'";
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
        extraConfig.from = "test@digital-scurf.org";
        extraConfig.domain = systemConfig.networking.hostName;
      };
      neomutt = {
        enable = true;
        sendMailCommand = "msmtpq --read-recipients";
        extraConfig = (folder-config config.accounts.email.accounts);
      };
      signature = {
        showSignature = "append";
        text = ''
          Daniel Silverstone (test)                  http://www.digital-scurf.org/
          PGP mail accepted and encouraged.            Key Id: 3CCE BABE 206C 3B69
        '';
      };
      mu.enable = true;
    };
  };

  services.mbsync.enable = true;
}
