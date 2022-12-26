{ lib, stdenv, fetchFromGitHub, pkg-config, curl, cmake, qtbase, ffmpeg
, obs-studio, ... }:

stdenv.mkDerivation rec {
  pname = "obs-face-tracker";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "norihiro";
    repo = "obs-face-tracker";
    rev = "${version}";
    sha256 = "sha256-DUfYENJ5Eo0tgsFfyFCjIS1Q5i74QXtNVkuPg0hka14=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = [ qtbase ffmpeg obs-studio curl ];

  dontWrapQtApps = true;

  #cmakeFlags = [
  #];

  #patches = [ ./fix-cmake.patch ];

  meta = with lib; {
    description = "An OBS Studio transitions and filters plugin";
    homepage = "https://github.com/Xaymar/obs-StreamFX";
    # maintainers = with maintainers; [ ahuzik ];
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
