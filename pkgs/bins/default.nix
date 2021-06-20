{ pkgs, ... }:

with pkgs; {
  desktop-shutdown = callPackage ./desktop-shutdown.nix { };
  neomutt-launcher = callPackage ./neomutt-launcher.nix { };
}
