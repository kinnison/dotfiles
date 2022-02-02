{ lib, stdenv, fetchFromGitHub, pkg-config, curl, cmake, qtbase, ffmpeg
, obs-studio, ... }:

stdenv.mkDerivation rec {
  pname = "obs-streamfx";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "Xaymar";
    repo = "obs-StreamFX";
    rev = "${version}";
    sha256 = "sha256-lDTpi5kVY8vb1Ft63K4oeRNgIDUVGqOfs/6yev2WZ5c=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = [ qtbase ffmpeg obs-studio curl ];

  dontWrapQtApps = true;

  cmakeFlags = [
    "-Dlibobs_SOURCE_DIR=${obs-studio}"
    "-DENABLE_CLANG=OFF"
    "-DSTRUCTURE_PACKAGEMANAGER=ON"
  ];

  patches = [ ./fix-cmake.patch ];

  meta = with lib; {
    description = "An OBS Studio transitions and filters plugin";
    homepage = "https://github.com/Xaymar/obs-StreamFX";
    # maintainers = with maintainers; [ ahuzik ];
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
