# User configuration valid on all systems
{ config, pkgs, lib, ... }:
let
  xdg = config.xdg;
in
{
  _module.args.dotroot = ./../dotfiles;

  home.activation = {
    xdg-prep-dir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD mkdir $VERBOSE_ARG -p '${xdg.cacheHome}/less' '${xdg.cacheHome}/zsh'
    '';
  };

  home.sessionVariables = {
    RUSTUP_HOME = "${xdg.dataHome}/rustup";
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };

  home.stateVersion = "20.09";
}
