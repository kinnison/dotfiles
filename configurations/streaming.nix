{ systemConfig, config, pkgs, folder-config, homeDirectory, ... }: {
  programs.obs-studio = {
    enable = true;
    plugins =
      [ pkgs.local.obs-streamfx pkgs.obs-studio-plugins.obs-move-transition ];
  };
}
