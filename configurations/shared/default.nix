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
  ];

  home.packages = with pkgs;
    [
      # We want Python 3 available
      python3
    ];
}
