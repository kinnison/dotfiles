{ lib, stdenv, fetchFromGitHub, pkg-config, curl, cmake, qtbase, ffmpeg
, obs-studio, ... }:

stdenv.mkDerivation rec {
  pname = "obs-face-tracker";
  version = "486ade5981e9fed8bbeb8b5d8dfd011d9b539a88";

  src = fetchFromGitHub {
    owner = "norihiro";
    repo = "obs-face-tracker";
    rev = "${version}";
    sha256 = "sha256-liz8KQG7xeo8AlU/5CwO/l6uN6XlWBHIocQd623Xo6U=";
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
