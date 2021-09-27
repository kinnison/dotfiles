{ stdenv, fetchgit, pkgs, lib, ... }:

stdenv.mkDerivation {
  name = "bitwarden-rofi";
  src = fetchgit {
    url = "https://github.com/mattydebie/bitwarden-rofi.git";
    rev = "62c95afd5634234bac75855dc705d4da5f4fab69";
    sha256 = "gv18H+J2pjT6d4qoLTcxUeo4r1xzXhBsOoFFpvl3Deo=";
  };

  configurePhase = "";
  buildPhase = "";
  installPhase = ''
    mkdir -p $out/bin
    cp bwmenu lib-bwmenu $out/bin/
    sed -i -e's|bw |${pkgs.bitwarden-cli}/bin/bw |g' $out/bin/bwmenu
    sed -i -e's|jq |${pkgs.jq}/bin/jq |g' $out/bin/bwmenu
    sed -i -e's|rofi |${pkgs.rofi}/bin/rofi |g' $out/bin/bwmenu
    sed -i -e's|keyctl |${pkgs.keyutils}/bin/keyctl |g' $out/bin/bwmenu
    sed -i -e's|# Options|${pkgs.keyutils}/bin/keyctl link @u @s|g' $out/bin/bwmenu
    sed -i -e's|xclip |${pkgs.xclip}/bin/xclip |g' $out/bin/bwmenu
    sed -i -e's|notify-send |${pkgs.libnotify}/bin/notify-send |g' $out/bin/bwmenu

    sed -i -e's|jq |${pkgs.jq}/bin/jq |g' $out/bin/lib-bwmenu
  '';

  meta = with lib; {
    description = "Bitwarden CLI interface using Rofi for menuing";
    homepage = "https://github.com/mattydebie/bitwarden-rofi/";
    # maintainers = [];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
