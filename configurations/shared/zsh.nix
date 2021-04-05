{ pkgs, dotroot, ... }:
{
  home.packages = with pkgs; [ zsh ];

  home.file.".zshrc".source = "${dotroot}/zshrc";
  home.file.".profile".source = "${dotroot}/profile";

  xdg.configFile.zsh = {
    recursive = true;
    source = "${dotroot}/zsh";
  };

  xdg.configFile.ls = {
    recursive = true;
    source = "${dotdir}/ls";
  };
}
