{ stdenv, fetchurl, pkgs, lib, autoPatchelfHook, ... }:

stdenv.mkDerivation rec {
  name = "sudoku-solver";
  version = "0.4.0-alpha";
  src = ./SudokuSolver-0.4.0-alpha-linux-x64.tar.gz;

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
    echo here
    find .
    echo there
    find $out
    echo done
    makeWrapper $out/dist/SudokuSolverConsole $out/bin/sudoku-solver --argv0 SudokuSolverConsole --prefix LD_LIBRARY_PATH : ${pkgs.openssl.out}/lib:${pkgs.icu.out}/lib
  '';

  meta = with lib; {
    homepage = "https://github.com/dclamage/SudokuSolver";
    description = "Rangsk's sudoku solver";
    license = licenses.gpl3;
  };
}
