{ pkgs, ... }:
#let msaClientID = "d73630d5-aac3-4fbf-8697-97bd414c80b1";
#in
{
  imports = [
    ./server.nix
    ./gui.nix
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
    # We enjoy minecraft, so multimc is our best bet for a launcher
    #(multimc.override { inherit msaClientID; })
    # But they were arses, so polymc
    #polymc
    # But they were bigger arses, so prismlauncher
    prismlauncher
    # We like to do hardware design, include kicad
    #kicad
  ];
  services.keybase.enable = true;
}
