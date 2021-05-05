{ pkgs, ... }:
with pkgs; {
  # Load our vscode extensions
  vscode = callPackage ./vscode { };
  bins = callPackage ./bins { };
}
