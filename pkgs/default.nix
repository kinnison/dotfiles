{ pkgs, ... }:
with pkgs; {
  # Load our vscode extensions
  vscode = callPackage ./vscode { };

  # Our little scripts
  bins = callPackage ./bins { };

  # Things we've packaged until they're in nixpkgs
  bitwarden-rofi = callPackage ./bitwarden-rofi.nix { };

  pulseaudio-control = callPackage ./pulseaudio-control.nix { };
  obs-streamfx = libsForQt5.callPackage ./obs-streamfx { };
  obs-face-tracker = libsForQt5.callPackage ./obs-face-tracker { };

  rust-analyzer-unwrapped = callPackage ./rust-analyzer {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
    inherit (pkgs.unstable) rustPlatform;
  };

  rustup = callPackage ./rustup {
    inherit (darwin.apple_sdk.frameworks) CoreServices Security;
    inherit (pkgs.unstable) rustPlatform;
  };

  sudoku-solver = callPackage ./sudoku-solver.nix { };
}
