{ stdenv, fetchurl, pkgs, lib, autoPatchelfHook, ... }:

stdenv.mkDerivation rec {
  name = "sudoku-solver";
  version = "0.3.2-alpha";
  src = fetchurl {
    url =
      "https://github.com/dclamage/SudokuSolver/releases/download/v${version}/SudokuSolver-${version}-linux-x64.tar.gz";
    sha256 = "sha256-NE5m6BPARsmSGwpLpChVSm9VoDuYPJeQWOEH82mGqd4=";
  };

  # Rangsk's tarball lacks a subdir
  setSourceRoot = "sourceRoot=`pwd`";

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = with pkgs; [
    stdenv.cc.cc
    zlib
    libkrb5
    openssl
    pkgs.makeWrapper
  ];

  configurePhase = "";
  buildPhase = "";
  installPhase = ''
    mkdir -p $out/dist
    cp -a . $out/dist/
    mkdir -p $out/bin
    makeWrapper $out/dist/SudokuSolverConsole $out/bin/sudoku-solver --argv0 SudokuSolverConsole --prefix LD_LIBRARY_PATH : ${pkgs.openssl.out}/lib:${pkgs.icu.out}/lib
  '';

  meta = with lib; {
    homepage = "https://github.com/dclamage/SudokuSolver";
    description = "Rangsk's sudoku solver";
    license = licenses.gpl3;
  };
}
