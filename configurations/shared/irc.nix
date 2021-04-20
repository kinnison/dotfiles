{ config, pkgs, dotroot, ... }:

{
  home.packages = with pkgs; [ quasselClient ];

  xdg.configFile."quassel-irc.org" = {
    recursive = true;
    source = "${dotroot}/quassel-irc.org";
    onChange = ''
      echo "Trying to configure quassel guff..."
      _setup_quasselclient () {
          local confroot password savepassword
          confroot="$HOME"/.config/quassel-irc.org
          touch $confroot/quasselclient.conf
          password=$((grep -F '1\Password=' $confroot/quasselclient.conf || true) | cut -d= -f2-)
          savepassword=$((grep -F '1\StorePassword=' $confroot/quasselclient.conf || true) | cut -d= -f2-)
          sed -e 's,@HOME@,'"$HOME"',; s/^1\\Password=.*$/1\\Password='"$password"'/; s/^1\\StorePassword=.*$/1\\StorePassword='"$savepassword"'/' < $confroot/quasselclient.conf.template > $confroot/quasselclient.conf
          test -r $confroot/settings.qss && echo "*** WARNING: Not replacing existing settings.qss"
          test -r $confroot/settings.qss || cp $confroot/settings.qss.template $confroot/settings.qss
      }
      _setup_quasselclient
      unset _setup_quasselclient
    '';
  };
}
