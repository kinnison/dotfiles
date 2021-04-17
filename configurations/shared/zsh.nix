{ pkgs, dotroot, ... }: {
  home.packages = with pkgs; [ zsh direnv ];

  services.lorri.enable = true;

  home.file.".zshrc".source = "${dotroot}/zshrc";
  home.file.".profile".source = "${dotroot}/profile";

  xdg.configFile.zsh = {
    recursive = true;
    source = "${dotroot}/zsh";
  };

  xdg.configFile.ls = {
    recursive = true;
    source = "${dotroot}/ls";
  };
}
