{ config, dotroot, homeDirectory, pkgs, ... }: {
  # config.systemd.user.services.sudoku-solver = {
  #   Unit = { Description = "Sudoku Solver"; };
  #   Service = {
  #     ExecStart = "${pkgs.local.sudoku-solver}/bin/sudoku-solver --listen";
  #   };
  #   Install = { WantedBy = [ "default.target" ]; };
  # };
  home.packages = with pkgs.local; [ sudoku-solver ];
}
