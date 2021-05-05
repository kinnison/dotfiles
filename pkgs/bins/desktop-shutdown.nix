{ stdenv, pkgs, rofi, ... }:
let mate-session-manager = pkgs.mate.mate-session-manager;
in stdenv.mkDerivation {
  pname = "desktop-shutdown";
  version = "1";
  src = ./bin;
  installPhase = ''
    mkdir -p $out/bin
    cp desktop-shutdown $out/bin/
  '';
  postFixup = ''
    sed -i 's|rofi|${rofi}/bin/rofi|' "$out/bin/desktop-shutdown"
    sed -i 's|mate-session-save|${mate-session-manager}/bin/mate-session-save|' "$out/bin/desktop-shutdown"
  '';
}
