{ pkgs, dotroot, ... }:
{
  home.packages = with pkgs; [ zsh ];

  home.file.".zshrc".source = "${dotroot}/zshrc";
  home.file.".profile".source = "${dotroot}/profile";

  xdg.configFile = {
    recursive = true;
    source = "${dotroot}/zsh";
  };
}
