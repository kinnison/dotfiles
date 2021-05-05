{ pkgs, ... }:

with pkgs; {
  desktop-shutdown = callPackage ./desktop-shutdown.nix { };
}
