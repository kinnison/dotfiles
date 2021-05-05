{ pkgs, ... }: {
  programs.rofi = {
    enable = true;
    theme = "solarized";
    package = pkgs.rofi.override { plugins = [ pkgs.rofi-emoji ]; };
  };
}
