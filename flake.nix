{
  description = "Daniel's dot files, and other home-manager based config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-20.09";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-20.09";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs:
    let
      make-home =
        { username ? "dsilvers"
        , homeDirectory ? "/home/${username}"
        , modules ? []
        }: {
          nixpkgs.overlays = [
            (
              final: prev: {
                unstable = import inputs.nixpkgs-unstable { system = prev.system; };
              }
            )
          ];

          imports = [ ./configurations ] ++ modules;
        };
    in
      {
        homeConfigurations = {
          test = make-home {
            modules = [
              ./configurations/shared/zsh
            ];
          };
        };
      }
      # Set up a "dev shell" that will work on all architectures
      // (
        inputs.flake-utils.lib.eachDefaultSystem (
          system:
            let
              pkgs = inputs.nixpkgs.legacyPackages.${system};
              unstable-pkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
            in
              {
                packages = import ./pkgs { inherit pkgs unstable-pkgs; };
                devShell = pkgs.mkShell { buildInputs = with pkgs; [ nixfmt ]; };
              }
        )
      );
}
