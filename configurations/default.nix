# User configuration valid on all systems
{ config, pkgs, lib, homeDirectory, ... }:
let
  xdg = config.xdg;
  folder-config = (import ./mail/folder-config.nix { inherit config lib; });
in {
  _module.args.dotroot = ./../dotfiles;
  _module.args.folder-config = folder-config;

  home.activation = {
    xdg-prep-dir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD mkdir $VERBOSE_ARG -p '${xdg.cacheHome}/less' '${xdg.cacheHome}/zsh'
    '';
    gnupg-prep-dir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD mkdir $VERBOSE_ARG -p '${homeDirectory}'/.gnupg
      $DRY_RUN_CMD chmod 0700 '${homeDirectory}'/.gnupg
    '';
  };

  home.sessionVariables = { RUSTUP_HOME = "${xdg.dataHome}/rustup"; };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };

  systemd.user.sockets.gpg-agent-ssh.Socket.ExecStartPost =
    "${pkgs.systemd}/bin/systemctl --user set-environment SSH_AUTH_SOCK=%t/gnupg/S.gpg-agent.ssh";

  home.stateVersion = "20.09";
}
