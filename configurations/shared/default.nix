{ pkgs, ... }:

{
  imports = [
    ./zsh.nix
    ./gui.nix
    ./git.nix
    ./ssh.nix
    ./vscode.nix
    ./pass.nix
    ./irc.nix
    ./rofi.nix
    ./bitwarden.nix
    ./spotify.nix
  ];

  home.packages = with pkgs; [
    # We want Python 3 available
    python3
    # We like to do hardware design, include kicad
    kicad
    unstable.minecraft
  ];
}
