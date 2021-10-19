{ stdenv, fetchgit, pkgs, lib, ... }:

stdenv.mkDerivation {
  name = "pulseaudio-control";
  src = fetchgit {
    url = "https://github.com/marioortizmanero/polybar-pulseaudio-control.git";
    rev = "5e2cd04bd2956a6b7a40dc7131e85900c415f0d2";
    sha256 = "CbB8aIdO3W8BCHcFwJgKU+mqpBc/WEzp2wvxSRBvA3Y=";
  };

  configurePhase = "";
  buildPhase = "";
  installPhase = ''
    mkdir -p $out/bin
    cp pulseaudio-control.bash $out/bin/pulseaudio-control
    #sed -i -e's|! pactl |! ${pkgs.pulseaudio}/bin/pactl |g' $out/bin/pulseaudio-control
  '';

  meta = with lib; {
    description = "CLI tool for use under polybar for PulseAudio control";
    homepage =
      "https://github.com/marioortizmanero/polybar-pulseaudio-control/";
    # maintainers = [];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
