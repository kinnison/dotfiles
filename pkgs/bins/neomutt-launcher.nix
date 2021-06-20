{ stdenv, pkgs, rofi, ... }:
stdenv.mkDerivation {
  pname = "neomutt-launcher";
  version = "1";
  src = ./bin;
  installPhase = ''
    mkdir -p $out/bin
    cp neomutt-launcher $out/bin/
  '';
}
