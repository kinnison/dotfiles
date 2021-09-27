{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # This gives us the `bw` CLI tool
    pkgs.bitwarden-cli
    # And this the bwmenu tool
    local.bitwarden-rofi
    # For bwmenu to work, we need xdotool in our session path
    xdotool
  ];

  # Sadly, currently there doesn't seem to be a way to pre-configure
  # the vault and username.

}
