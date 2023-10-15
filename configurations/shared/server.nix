{ pkgs, ... }:
{
  imports = [
    ./zsh.nix
    ./git.nix
    ./ssh.nix
  ];

}
